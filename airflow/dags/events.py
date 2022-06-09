
from datetime import datetime, timedelta
from textwrap import dedent
# import configparser

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.dummy import DummyOperator

# config = configparser.ConfigParser()

start_date = datetime(2022, 6, 9, 12, 0, 1)
default_args = {
    'depends_on_past': False,
    'email': ['timmine7@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 2,
    'retry_delay': timedelta(minutes=2)
}

with DAG(
    'data_cleanup',
    default_args=default_args,
    description='clean up all events from s3 to s3',
    schedule_interval='@hourly',
    start_date=start_date,
    tags=['songstreams'],
) as dag:
    begin_execution = DummyOperator(
        task_id='begin_execution'
    )
    end_execution = DummyOperator(
        task_id='end_execution'
    )

begin_execution >> end_execution
