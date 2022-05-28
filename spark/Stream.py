from pyspark.sql.functions import from_json, col


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
            .option("header", True)\
            .option("path", f'{path}/{topic}')\
            .option("checkpointLocation", f'{path}/checkpoint/{topic}')\
            .trigger(processingTime="120 seconds")\
            .outputMode("append")
        return response

    def process(stream, schema):
        response = stream.\
            selectExpr("CAST(value AS STRING)")
        return response
