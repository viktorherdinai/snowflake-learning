from snowflake.snowpark import Session # as spark
import snowflake.snowpark.functions as f

def model(dbt, session: Session):
    dbt.config(metarialized="view")
    fact_weather_enriched = dbt.ref("fact_weather_enriched") #.to_pandas()
    result = fact_weather_enriched.groupBy("city").agg(f.min("temperature").alias("min_temperature"))
    return result