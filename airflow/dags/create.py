import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.decorators import task
from airflow.operators.dummy import DummyOperator
from airflow.providers.amazon.aws.operators.redshift import RedshiftSQLOperator

from helpers.sql.statements import Query

S3_BUCKET = os.getenv("AWS_S3_BUCKET_CLEAN", "test-bucket")
S3_KEY__AUTH_EVENTS = os.getenv("AUTH_EVENTS", "auth_events/auth_events")
SCHEMA = "dev"
DATABASE = "sonngstreams"

tables = {"auth_events": "auth_events",
          "listen_events": "listen_events", "page_views": "page_view_events"}

start_date = datetime.now()
default_args = {
    'depends_on_past': False,
    'email': ['timmine7@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 2,
    'retry_delay': timedelta(minutes=1)
}

with DAG(
    'create_properties',
    default_args=default_args,
    description='creates schema and tables needed for current pipeline. This DAG is to be run only once.',
    start_date=start_date,
    tags=['songstreams'],
) as dag:

    begin_execution = DummyOperator(
        task_id='begin_execution'
    )

    create_schema = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='create_schema',
        sql=Query.create_schema(SCHEMA, DATABASE)
    )

    drop_table__auth_events = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='drop_table__auth_events',
        sql=Query.drop_table(SCHEMA, tables['auth_events'], DATABASE)
    )
    drop_table__listen_events = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='drop_table__listen_events',
        sql=Query.drop_table(SCHEMA, tables['listen_events'], DATABASE)
    )
    drop_table__page_view_events = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='drop_table__page_view_events',
        sql=Query.drop_table(SCHEMA, tables['page_views'], DATABASE)
    )

    create_table__auth_events = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='create_table__auth_events',
        sql=Query.create_table(SCHEMA, tables['auth_events'], DATABASE)
    )
    create_table__listen_events = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='create_table__listen_events',
        sql=Query.create_table(SCHEMA, tables['listen_events'], DATABASE)
    )
    create_table__page_view_events = RedshiftSQLOperator(
        redshift_conn_id="redshift_default",
        task_id='create_table__page_view_events',
        sql=Query.create_table(SCHEMA, tables['page_views'], DATABASE)
    )

    end_execution = DummyOperator(
        task_id='end_execution'
    )

begin_execution >> create_schema
create_schema >> drop_table__auth_events
drop_table__auth_events >> create_table__auth_events
create_schema >> drop_table__listen_events
drop_table__listen_events >> create_table__listen_events
create_schema >> drop_table__page_view_events
drop_table__page_view_events >> create_table__page_view_events
create_table__auth_events >> end_execution
create_table__page_view_events >> end_execution
create_table__listen_events >> end_execution
