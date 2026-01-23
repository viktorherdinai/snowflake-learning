# dbt Testing, Analysis, and Snapshots Guide

## Overview
This guide explains how to use the tests, analyses, and snapshots in this project.

---

## 📸 SNAPSHOTS

### What are Snapshots?
Snapshots capture **historical changes** to dimension tables using **Type 2 Slowly Changing Dimensions (SCD2)**.

### Available Snapshots:
- `dim_city_snapshot.sql` - Tracks changes to city coordinates and country assignments

### How to Run Snapshots:
```bash
# Run all snapshots
dbt snapshot

# Run specific snapshot
dbt snapshot --select dim_city_snapshot
```

### What Gets Created:
- Table: `WEATHER_DB.SNAPSHOTS.DIM_CITY_SNAPSHOT`
- Columns added:
  - `dbt_valid_from` - When this version became active
  - `dbt_valid_to` - When this version was replaced (NULL if current)
  - `dbt_scd_id` - Unique ID for each version
  - `dbt_updated_at` - Timestamp of snapshot run

### Example Use Case:
```sql
-- See all historical versions of Berlin
SELECT * 
FROM WEATHER_DB.SNAPSHOTS.DIM_CITY_SNAPSHOT 
WHERE city = 'Berlin'
ORDER BY dbt_valid_from;

-- See what cities changed in the last run
SELECT * 
FROM WEATHER_DB.SNAPSHOTS.DIM_CITY_SNAPSHOT 
WHERE dbt_updated_at = (SELECT MAX(dbt_updated_at) FROM WEATHER_DB.SNAPSHOTS.DIM_CITY_SNAPSHOT)
  AND dbt_valid_to IS NULL;
```

---

## ✅ TESTS

### What are Tests?
Tests validate **data quality** and fail if they return any rows (rows = problems).

### Available Tests:

#### 1. `assert_temperature_realistic.sql`
**Purpose:** Ensures temperatures are within realistic bounds (-100°C to +60°C)  
**Fails if:** Any temperature is outside this range

#### 2. `assert_all_weather_has_city.sql`
**Purpose:** Ensures all weather records can be matched to a city  
**Fails if:** Weather data exists with coordinates not in `dim_city`

#### 3. `assert_no_duplicate_hourly_readings.sql`
**Purpose:** Ensures no duplicate readings per city per hour  
**Fails if:** Same city has multiple temperatures for the same hour

### How to Run Tests:
```bash
# Run all tests
dbt test

# Run specific test
dbt test --select assert_temperature_realistic

# Run tests for specific model
dbt test --select fact_weather_enriched

# Run tests including seed tests (defined in seeds/properties.yml)
dbt test --select dim_city
```

### Example Output:
```
12:45:01  Running test assert_temperature_realistic
12:45:02  PASS assert_temperature_realistic
12:45:02  Running test assert_all_weather_has_city
12:45:03  FAIL 1 assert_all_weather_has_city
12:45:03    Got 1 result, expected 0.
```

---

## 📊 ANALYSES

### What are Analyses?
Analyses are **ad-hoc queries** for exploration. They:
- Are **NOT** materialized (no tables/views created)
- Are **compiled** so you can use dbt features (ref, sources, macros)
- Are meant for **manual execution** or sharing with analysts

### Available Analyses:

#### 1. `temperature_anomalies.sql`
**Purpose:** Find cities with extreme temperature changes (>10°C in 1 hour)  
**Use Case:** Data quality checks, extreme weather event detection

#### 2. `country_weather_comparison.sql`
**Purpose:** Compare weather patterns between countries  
**Use Case:** Regional analysis, reporting dashboards

#### 3. `hourly_temperature_patterns.sql`
**Purpose:** Analyze temperature distribution by hour of day  
**Use Case:** Understanding daily temperature cycles

### How to Run Analyses:
```bash
# Compile the analysis (generates SQL in target/compiled/)
dbt compile --select temperature_anomalies

# Then copy the compiled SQL from target/compiled/my_weather_app/analyses/
# and run it in Snowflake UI or SQL client
```

### Alternative - Run Directly:
You can also run analyses using dbt's run-operation with a custom macro:

```bash
# Create a macro to run an analysis
# macros/run_analysis.sql:
{% macro run_analysis(analysis_name) %}
    {% set query %}
        {% include 'analyses/' ~ analysis_name ~ '.sql' %}
    {% endset %}
    {% do run_query(query) %}
{% endmacro %}

# Then run:
dbt run-operation run_analysis --args '{analysis_name: temperature_anomalies}'
```

---

## 🔄 Full Workflow

### Development Workflow:
```bash
# 1. Load raw data
dbt run-operation load_raw_weather

# 2. Load dimension tables
dbt seed

# 3. Build all models
dbt build

# 4. Run tests
dbt test

# 5. Create/update snapshots
dbt snapshot

# 6. Run ad-hoc analysis
dbt compile --select temperature_anomalies
# Then copy SQL from target/compiled and run in Snowflake
```

### CI/CD Workflow:
```bash
# Full pipeline with testing
dbt seed && dbt build && dbt test && dbt snapshot
```

---

## 📈 Monitoring & Best Practices

### Test Frequency:
- **After every dbt run** - Catches data quality issues immediately
- **In CI/CD** - Prevents bad data from reaching production

### Snapshot Frequency:
- **Daily** - Captures dimension changes without overwhelming storage
- **After seed updates** - When dimension data changes

### Analysis Usage:
- **Exploratory phase** - Understanding data patterns
- **Reporting** - Share compiled SQL with BI tools
- **Documentation** - Show stakeholders what's possible

---

## 🎯 Next Steps

1. **Add more tests** to `seeds/properties.yml` for column-level validation
2. **Create custom generic tests** in `tests/generic/` for reusable test logic
3. **Add data freshness checks** to `sources.yml` to monitor data staleness
4. **Create more analyses** for specific business questions
5. **Snapshot fact tables** if you need to track historical metric changes

---

## Resources
- [dbt Testing Documentation](https://docs.getdbt.com/docs/build/tests)
- [dbt Snapshots Documentation](https://docs.getdbt.com/docs/build/snapshots)
- [dbt Analyses Documentation](https://docs.getdbt.com/docs/build/analyses)

