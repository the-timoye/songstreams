from email.policy import default
from pyspark.sql.types import (IntegerType,
                               StringType,
                               DoubleType,
                               StructField,
                               StructType,
                               LongType,
                               BooleanType)


class Schema():
    @staticmethod
    def listen_events():
        return StructType([
            StructField("artist", StringType(), True),
            StructField("song", StringType(), True),
            StructField("ts", LongType(), True),
            StructField("sessionId", LongType(), True),
            StructField("auth", StringType(), True),
            StructField("level", StringType(), True),
            StructField("itemInSession", IntegerType(), True),
            StructField("city", StringType(), True),
            StructField("zip", IntegerType(), True),
            StructField("state", StringType(), True),
            StructField("userAgent", StringType(), True),
            StructField("lon", DoubleType(), True),
            StructField("lat", DoubleType(), True),
            StructField("userId", LongType(), True),
            StructField("lastName", StringType(), True),
            StructField("firstName", StringType(), True),
            StructField("gender", StringType(), True),
            StructField("registration", LongType(), True)
        ])

    def page_views_events():
        return StructType([
            StructField("ts", LongType(), True),
            StructField("sessionId", LongType(), True),
            StructField("page", StringType(), True),
            StructField("auth", StringType(), True),
            StructField("method", StringType(), True),
            StructField("status", IntegerType(), True),
            StructField("level", StringType(), True),
            StructField("itemInSession", IntegerType(), True),
            StructField("city", StringType(), True),
            StructField("zip", IntegerType(), True),
            StructField("state", StringType(), True),
            StructField("userAgent", StringType(), True),
            StructField("lon", DoubleType(), True),
            StructField("lat", DoubleType(), True),
            StructField("userId", IntegerType(), True),
            StructField("lastName", StringType(), True),
            StructField("firstName", StringType(), True),
            StructField("gender", StringType(), True),
            StructField("registration", LongType(), True),
            StructField("artist", StringType(), True),
            StructField("song", StringType(), True),
            StructField("duration", DoubleType(), True)
        ])

    def auth_events():
        return StructType([
            StructField("ts", LongType(), True),
            StructField("sessionId", IntegerType(), True),
            StructField("level", StringType(), True),
            StructField("itemInSession", IntegerType(), True),
            StructField("city", StringType(), True),
            StructField("zip", IntegerType(), True),
            StructField("state", StringType(), True),
            StructField("userAgent", StringType(), True),
            StructField("lon", DoubleType(), True),
            StructField("lat", DoubleType(), True),
            StructField("userId", IntegerType(), True),
            StructField("lastName", StringType(), True),
            StructField("firstName", StringType(), True),
            StructField("gender", StringType(), True),
            StructField("registration", LongType(), True),
            StructField("success", BooleanType(), True)
        ])
