import os
from pyspark.sql import SparkSession
from lake.Schema import Schema
from lake.Stream import Stream

from dotenv import load_dotenv
load_dotenv()

raw_file_path = os.getenv("AWS_S3_BUCKET_RAW")
clean_file_path = os.getenv("AWS_S3_BUCKET_CLEAN")

ACCESS_KEY = os.getenv("AWS_ACCESS_KEY_ID")
SECRET_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
KAFKA_HOST = os.getenv('KAFKA_HOST')
KAFKA_PORT = os.getenv('KAFKA_PORT')


os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-streaming-kafka-0-10_2.12:3.2.1,org.apache.spark:spark-sql-kafka-0-10_2.12:3.2.1,org.apache.hadoop:hadoop-common:3.0.0,org.apache.hadoop:hadoop-client:3.0.0,org.apache.hadoop:hadoop-aws:3.0.0 pyspark-shell'

spark = SparkSession.builder.appName("songstreams")\
    .config('spark.hadoop.fs.s3a.aws.credentials.provider', 'org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider')\
    .getOrCreate()

spark.sparkContext._jsc.hadoopConfiguration().set(
    "fs.s3a.access.key", ACCESS_KEY)
spark.sparkContext._jsc.hadoopConfiguration().set(
    "fs.s3a.secret.key", SECRET_KEY)
spark.sparkContext._jsc.hadoopConfiguration().set(
    "fs.s3a.endpoint", "s3.amazonaws.com")

# ======: READ : ======
page_view_events = Stream.read(spark, host=KAFKA_HOST,
                               port=KAFKA_PORT, topic='page_view_events').load()
listen_events = Stream.read(spark, host=KAFKA_HOST,
                            port=KAFKA_PORT, topic='listen_events').load()
auth_events = Stream.read(spark, host=KAFKA_HOST,
                          port=KAFKA_PORT, topic='auth_events').load()


# ======: PROCESS : ======
page_view_schema = Schema.page_views_events()
raw_page_view_events, clean_page_view_events = Stream.process(
    page_view_events, page_view_schema, 'page_view_events')
listen_events_schema = Schema.listen_events()
raw_listen_events, clean_listen_events = Stream.process(
    listen_events, listen_events_schema, 'listen_events')
auth_events_schema = Schema.auth_events()
raw_auth_events, clean_auth_events = Stream.process(
    auth_events, auth_events_schema, 'auth_events')

# ======: WRITE RAW : ======

Stream.write(raw_page_view_events, f"{raw_file_path}",
             'csv', topic='page_view_events').start()
Stream.write(raw_auth_events, f'{raw_file_path}', 'csv',
             topic='auth_events').start()
Stream.write(raw_listen_events, f'{raw_file_path}', 'csv',
             topic='listen_events').start()


# ======: WRITE CLEANED : ======
Stream.write(clean_page_view_events, f'{clean_file_path}',
             'csv', topic='page_view_events').start()
Stream.write(clean_auth_events, f'{clean_file_path}', 'csv',
             topic='auth_events').start()
Stream.write(clean_listen_events, f'{clean_file_path}', 'csv',
             topic='listen_events').start()

spark.streams.awaitAnyTermination()
