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
│   ├── bronze/         # Raw data parsing
│   ├── silver/         # Cleaned & enriched data
│   ├── gold/           # Business metrics & aggregations
│   └── src/            # Source definitions
├── seeds/              # Reference data (dimensions)
├── snapshots/          # Historical dimension tracking (SCD Type 2)
├── tests/              # Data quality tests
├── analyses/           # Ad-hoc analytical queries
├── macros/             # Reusable dbt macros
└── setup/              # Database initialization scripts
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
setup/init_db.sql        -- Create database & schemas
setup/init_tables.sql    -- Create raw tables
setup/load_raw_data.sql  -- Load data from stage
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
- **Temperature validation** - Ensures realistic temp ranges
- **City mapping** - Validates all weather has city reference
- **Duplicate detection** - Checks for duplicate hourly readings
- **Column-level tests** - Not null, relationships, accepted ranges

### 📸 Snapshots (Historical Tracking)
- **dim_city_snapshot** - Tracks changes to city dimensions over time
- Uses SCD Type 2 strategy

### 📈 Analyses (Ad-hoc Queries)
- **Temperature anomalies** - Detect extreme temp changes
- **Country comparison** - Compare weather patterns by country
- **Hourly patterns** - Analyze daily temperature cycles

## 📚 Documentation
- **[DBT_FEATURES.md](DBT_FEATURES.md)** - Complete guide to tests, snapshots, analyses
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick command reference

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


