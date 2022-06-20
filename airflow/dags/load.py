import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.decorators import task
from airflow.operators.dummy import DummyOperator
from airflow.providers.amazon.aws.transfers.s3_to_redshift import S3ToRedshiftOperator

from helpers.sql.statements import Query

S3_BUCKET = os.getenv("AWS_S3_BUCKET_CLEAN", "songstreams")
S3_KEY__AUTH_EVENTS = os.getenv(
    "AUTH_EVENTS", "clean/auth_events/__year=2022/__month=6")
S3_KEY__LISTEN_EVENTS = os.getenv(
    "LISTEN_EVENTS", "clean/listen_events/__year=")
S3_KEY__PAGE_VIEW_EVENTS = os.getenv(
    "PAGE_VIEW_EVENTS", "clean/page_view_events/__year=")
SCHEMA = "dev"
DATABASE = "sonngstreams"
AWS_REGION = os.getenv("REGION", "eu-west-2")

tables = {"auth_events": "auth_events",
          "listen_events": "listen_events", "page_views": "page_view_events"}

start_date = datetime.now()
default_args = {
    'depends_on_past': True,
    'email': ['timmine7@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 1,
    'retry_delay': timedelta(seconds=30)
}


with DAG(
    'load_data',
    default_args=default_args,
    description='loads data. first from s3 to redshift, then triggers others with dbt',
    start_date=start_date,
    tags=['songstreams'],
) as dag:

    begin_execution = DummyOperator(
        task_id='begin_execution'
    )

    copy__auth_events_to_redshift = S3ToRedshiftOperator(
        redshift_conn_id="redshift_default",
        aws_conn_id="aws_default",
        method="APPEND",
        s3_bucket=S3_BUCKET,
        s3_key=S3_KEY__AUTH_EVENTS,
        column_list=["timestamp", "session_id", "level", "item_in_session", "city", "zip", "state", "user_agent", "longitude", "latitude", "user_id",
                     "last_name", "first_name", "gender", "registration", "success", "year", "month", "abs_date", "hour", "day", "day_of_week", "is_weekend"],
        schema='dev',
        table="auth_events",
        copy_options=['csv', 'DELIMITER \',\'',
                      'IGNOREHEADER 1', f'region \'{AWS_REGION}\''],
        task_id='copy__auth_events_to_redshift',
    )

    copy__page_view_to_redshift = S3ToRedshiftOperator(
        redshift_conn_id="redshift_default",
        aws_conn_id="aws_default",
        method="APPEND",
        s3_bucket=S3_BUCKET,
        s3_key=S3_KEY__PAGE_VIEW_EVENTS,
        schema='dev',
        table="page_view_events",
        copy_options=['csv', 'DELIMITER \',\'', 'IGNOREHEADER 1',
                      f'region \'{AWS_REGION}\''],
        task_id='copy__page_view_events_to_redshift',
        column_list=["timestamp", "session_id", "page", "auth", "method", "status", "level", "item_in_session", "city", "zip", "state", "user_agent", "longitude", "latitude",
                     "user_id", "last_name", "first_name", "gender", "registration", "artist", "song", "duration", "year", "month", "abs_date", "hour", "day", "day_of_week", "is_weekend"]
    )

    copy__listen_events_to_redshift = S3ToRedshiftOperator(
        redshift_conn_id="redshift_default",
        aws_conn_id="aws_default",
        method="APPEND",
        s3_bucket=S3_BUCKET,
        s3_key=S3_KEY__LISTEN_EVENTS,
        schema='dev',
        table="listen_events",
        copy_options=['csv', 'DELIMITER \',\'', 'IGNOREHEADER 1',
                      f'region \'{AWS_REGION}\''],
        task_id='copy__listen_events_to_redshift',
        column_list=["artist", "song", "timestamp", "session_id", "auth", "level", "item_in_session", "city", "zip", "state", "user_agent", "longitude",
                     "latitude", "user_id", "last_name", "first_name", "gender", "registration", "year", "month", "abs_date", "hour", "day", "day_of_week", "is_weekend"]
    )

    end_execution = DummyOperator(
        task_id='end_execution'
    )


begin_execution >> copy__auth_events_to_redshift
begin_execution >> copy__listen_events_to_redshift
begin_execution >> copy__page_view_to_redshift
copy__page_view_to_redshift >> end_execution
copy__listen_events_to_redshift >> end_execution
copy__auth_events_to_redshift >> end_execution
