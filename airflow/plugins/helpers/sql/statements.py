from helpers.sql.table_columns import table_columns


class Query:

    """contains all query formats (drops, creates, and inserts)"""

    @staticmethod
    def drop_schema(schema: str):
        """SQL statement that checks if a schema exists and drops it if true"""
        return f"""
            DROP SCHEMA IF EXISTS {schema};
        """

    @staticmethod
    def drop_table(table_name: str):
        """SQL statement that checks if a _table_ exists and drops it if true"""
        return f"""
            DROP TABLE IF EXISTS songstreams.{table_name};
        """

    @staticmethod
    def create_schema(schema: str):
        """
        @desctiption: SQL statement to create a schema only if it exists
        @params:
            schema(str): the name of the schema to be created.
        @returns: (str) SQL Create Schema statement
        """
        return f"""
            CREATE SCHEMA IF NOT EXISTS {schema}
        """

    @staticmethod
    def create_table(schema: str, table_name: str):
        """
            @desctiption: SQL statement to create a tabke only if it exists
            @params:
                schema(str): the name of the schema
                table(str): the name of the table to be created
            @returns: (str) SQL Create Table statement
        """
        return f"""
            CREATE TABLE IF NOT EXISTS {schema}.{table_name}(
                {table_columns[table_name]}
            )
    """
