# snowflake-learning
Personal training on snowflake/dbt using weather data

## 🎯 Project Overview
This project demonstrates a modern data pipeline using:
- **Weather API data** (Open-Meteo)
- **Snowflake** (cloud data warehouse)
- **dbt** (data transformation)
- **Bronze/Silver/Gold architecture** (medallion architecture)

## 📂 Project Structure
```
├── models/              # dbt transformation models
│   ├── bronze/         # Raw data parsing (bronze_weather.sql)
│   ├── silver/         # Cleaned & enriched data (silver_weather.sql, fact_weather_enriched.sql)
│   ├── gold/           # Business metrics & aggregations (avg_temp_by_country.sql, min_temp_by_city.py)
│   └── src/            # Source definitions (sources.yml)
├── seeds/              # Reference data (dim_city.csv, dim_country.csv)
├── snapshots/          # Historical dimension tracking (SCD Type 2)
├── tests/              # Data quality tests
├── analyses/           # Ad-hoc analytical queries
├── macros/             # Reusable dbt macros (generate_schema_name.sql, round_coordinates.sql)
├── setup/              # Database & Snowflake initialization scripts
├── raw-data/           # Local JSON files from API fetches
└── main.py             # Python script to fetch weather data from Open-Meteo API
```

## 🚀 Quick Start

### 1. Setup Environment
```bash
# Set Snowflake credentials
$env:SNOWFLAKE_ACCOUNT="your_account"
$env:SNOWFLAKE_USER="your_user"
$env:SNOWFLAKE_PASSWORD="your_password"
```

### 2. Run Setup Scripts in Snowflake UI
```sql
-- In Snowflake, run these in order:
setup/init_db.sql              -- Create database (WEATHER_DB) & schemas (RAW, BRONZE, SILVER, GOLD)
setup/init_tables.sql          -- Create raw tables
setup/load_raw_data.sql        -- Load data from stage (@WEATHER_DB.RAW.UPLOADS)
setup/external_access.sql      -- (Optional) Setup external access
setup/deploy_dbt_to_snowsight.sql  -- (Optional) Deploy dbt project to Snowsight
```

### 3. Run dbt Pipeline
```bash
dbt seed             # Load dimension tables
dbt build            # Build all models
dbt test             # Run data quality tests
dbt snapshot         # Track dimension changes
```

## 📊 New Features Added

### ✅ Tests (Data Quality)
- **assert_temperature_realistic** - Ensures temp values are within -100°C to +60°C
- **assert_no_duplicate_hourly_readings** - Checks for duplicate hourly readings per city
- **Column-level tests** (in schema.yml) - Not null, relationships to dimensions

### 📸 Snapshots (Historical Tracking)
- **dim_city_snapshot** - Tracks changes to city dimensions over time
- Uses SCD Type 2 strategy

### 📈 Analyses (Ad-hoc Queries)
- **Temperature anomalies** - Detect extreme temp changes
- **Country comparison** - Compare weather patterns by country
- **Hourly patterns** - Analyze daily temperature cycles


## 🏗️ Architecture

### Data Flow
```
Open-Meteo API (main.py)
    ↓
Snowflake Stage (WEATHER_DB.RAW.UPLOADS)
    ↓
RAW Layer (WEATHER_DB.RAW.WEATHER)
    ↓
BRONZE Layer (Parse JSON)
    ↓
SILVER Layer (Clean & Flatten)
    ↓
GOLD Layer (Business Metrics)
```

### Schemas
- **RAW** - Raw JSON data from API
- **BRONZE** - Parsed JSON
- **SILVER** - Cleaned/enriched data + dimension tables
- **GOLD** - Business-ready aggregations
- **SNAPSHOTS** - Historical dimension tracking

## 🔧 Technologies
- **dbt** - Data transformation framework
- **Snowflake** - Cloud data warehouse
- **Python** - API data fetching
- **SQL** - Data transformations

## 📄 Useful Links
- [Snowflake signup](https://signup.snowflake.com/)
- [dbt documentation](https://docs.getdbt.com/docs/introduction)
- [Snowflake SQL documentation](https://docs.snowflake.com/en/reference)
- [Snowpark DataFrame documentation](https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/snowpark/dataframe)
