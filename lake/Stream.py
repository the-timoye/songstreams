from pyspark.sql.functions import (
    from_json,
    col, month,
    hour,
    dayofmonth,
    col,
    year, dayofweek, date_trunc)

from lake.helpers import rename_columns, string_decode

new_column_names = {
    'ts': 'timestamp',
    'sessionId': 'session_id',
    'itemInSession': 'item_in_session',
    'userAgent': 'user_agent',
    'lon': 'longitude',
    'lat': 'latitude',
    'userId': 'user_id',
    'lastName': 'last_name',
    'firstName': 'first_name'
}


class Stream():
    @staticmethod
    def read(spark, host, port, topic):
        response = spark.readStream.format("kafka").\
            option(
            "kafka.bootstrap.servers", f"{host}:{port}").\
            option("startingOffsets", "earliest").\
            option("subscribe", topic).\
            option("includeHeaders", True)
        return response

    def write(stream, path, format, topic):
        response = stream.writeStream\
            .format(format)\
            .partitionBy('__year', '__month',)\
            .option("header", True)\
            .option("path", f'{path}/{topic}')\
            .option("checkpointLocation", f'{path}/checkpoint/{topic}')\
            .trigger(processingTime="150 seconds")\
            .outputMode("append")
        return response

    def process(stream, schema, topic):
        raw_response = (stream
                        .selectExpr("CAST(value AS STRING)")
                        .select(
                            from_json(col("value"), schema).alias(
                                "data")
                        )
                        .select("data.*")
                        )
        raw_response = raw_response.withColumn("ts", (col("ts")/1000).cast("timestamp"))\
            .withColumn("__year", year(col("ts")))\
            .withColumn("year", year(col("ts")))\
            .withColumn("month", month(col("ts")))\
            .withColumn("abs_date", date_trunc("dd", col("ts")))\
            .withColumn("__month", month(col("ts")))\
            .withColumn("hour", hour(col("ts")))\
            .withColumn("day", dayofmonth(col("ts")))\
            .withColumn("day_of_week", dayofweek(col('ts')))\
            .withColumn("is_weekend", dayofweek(col("ts")).isin(1, 7).cast("boolean"))

        clean_response = rename_columns(raw_response, new_column_names)
        clean_response = clean_response.withColumn(
            "user_agent", string_decode("user_agent"))
        if topic not in ["auth_events"]:
            clean_response = clean_response\
                .withColumn("song", string_decode("song"))\
                .withColumn("artist", string_decode("artist"))

        clean_response = clean_response\
            .na.fill(value=-404)\
            .na.fill(value='N/A')

        return raw_response, clean_response
