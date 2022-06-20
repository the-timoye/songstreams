from pyspark.sql.functions import udf


def rename_columns(df, columns: dict):
    """
    @description: Data Cleaning. Helps with renaming columns
    @params:
        df (DataFrame): A spark DataFrame
        columns (dict): key value pair. The key should be the current name of the column. The value, the preferred new name of the same column.
    @returns
        A new dataframe with columns renamed
    """
    new_df = df
    for key, value in columns.items():
        new_df = new_df.withColumnRenamed(key, value)

    return new_df


@udf
def string_decode(s, encoding='utf-8'):
    if s:
        s = s.replace("\\", "")
        return s.replace('"', "")
    else:
        return s


# "".encode("latin1").decode(
#     "unicode-escape").encode("latin1").decode("utf-8").strip('\"')
# "".str
