import json
import os
import csv
from pyspark.sql import SparkSession
from pyspark.sql import SparkSession
from Schema import Schema
from Stream import Stream

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))
file = os.path.join(__location__, "streams")

os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-streaming-kafka-0-10_2.12:3.2.0,org.apache.spark:spark-sql-kafka-0-10_2.12:3.2.0 pyspark-shell'

spark = SparkSession.builder.appName("songstreams").getOrCreate()


# ======: READ : ======
page_view_events = Stream.read(spark, host='localhost',
                               port=9092, topic='page_view_events').load()
listen_events = Stream.read(spark, host='localhost',
                            port=9092, topic='listen_events').load()

auth_events = Stream.read(spark, host='localhost',
                          port=9092, topic='auth_events').load()


# ======: PROCESS : ======
page_view_schema = Schema.page_views_events()
page_view_events = Stream.process(page_view_events, page_view_schema)

listen_events_schema = Schema.listen_events()
listen_events = Stream.process(listen_events, listen_events_schema)

auth_events_schema = Schema.auth_events()
auth_events = Stream.process(auth_events, auth_events_schema)


# ======: WRITE : ======
page_view_events = Stream.write(page_view_events, f'{file}/page_view_events',
                                'csv', topic='page_view_events').start()

auth_events = Stream.write(auth_events, f'{file}/auth_events', 'csv',
                           topic='auth_events').start()

listen_events = Stream.write(listen_events, f'{file}/listen_events', 'csv',
                             topic='listen_events').start()


spark.streams.awaitAnyTermination()
