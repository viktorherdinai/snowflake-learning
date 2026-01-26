from snowflake.snowpark import Session  # as spark
import snowflake.snowpark.functions as f


def model(dbt, session: Session):
    # This function is needed for dbt to recognize this script as a model
    fact_weather_enriched = dbt.ref("fact_weather_enriched")  # .to_pandas()
    result = fact_weather_enriched.groupBy("city").agg(f.min("temperature").alias("min_temperature"))
    return result
