-- ============================================================================
-- Deploy dbt Project to Snowsight (Native Snowflake dbt)
-- ============================================================================
-- This script sets up Git integration and deploys the dbt project to Snowflake
-- Run this if you want to use Snowsight's native dbt interface
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE WEATHER_DB;
USE SCHEMA RAW;

-- ============================================================================
-- Step 1: Create API Integration for Git
-- ============================================================================
-- Note: Replace the URL with your actual Git repository
-- Supported providers: GitHub, GitLab, Bitbucket

CREATE API INTEGRATION IF NOT EXISTS WEATHER_GIT_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE
  COMMENT = 'Git integration for weather dbt project';

-- Verify the integration was created
SHOW API INTEGRATIONS LIKE 'WEATHER_GIT_INTEGRATION';

-- ============================================================================
-- Step 2: Create Git Repository
-- ============================================================================
-- Note: Replace with your actual repository URL

CREATE GIT REPOSITORY IF NOT EXISTS WEATHER_DB.RAW.WEATHER_DBT_REPO
  API_INTEGRATION = WEATHER_GIT_INTEGRATION
  ORIGIN = 'https://github.com/viktorherdinai/snowflake-learning.git'  -- UPDATE THIS
  COMMENT = 'Weather dbt project repository';

-- Verify the repository was created
SHOW GIT REPOSITORIES IN SCHEMA WEATHER_DB.RAW;

-- ============================================================================
-- Step 3: Create dbt Project
-- ============================================================================
-- This creates a native Snowflake dbt project that can be managed in Snowsight

CREATE DBT PROJECT IF NOT EXISTS WEATHER_DB.RAW.WEATHER_DBT_PROJECT
  FROM '@WEATHER_DB.RAW.WEATHER_DBT_REPO/branches/main'
  COMMENT = 'Weather data transformation dbt project'
  DEFAULT_TARGET = 'dev';

-- Verify the dbt project was created
SHOW DBT PROJECTS IN SCHEMA WEATHER_DB.RAW;

-- ============================================================================
-- Step 4: Grant Permissions (if needed for other roles)
-- ============================================================================
DESCRIBE DBT PROJECT WEATHER_DB.RAW.WEATHER_DBT_PROJECT;
-- Example: Grant usage to other roles
-- GRANT USAGE ON DBT PROJECT WEATHER_DB.RAW.WEATHER_DBT_PROJECT TO ROLE DEVELOPER;

-- ============================================================================
-- Additional Commands for Managing the dbt Project
-- ============================================================================

-- To execute a dbt run:
-- EXECUTE DBT PROJECT WEATHER_DB.RAW.WEATHER_DBT_PROJECT COMMAND 'dbt run';

-- To execute dbt build:
-- EXECUTE DBT PROJECT WEATHER_DB.RAW.WEATHER_DBT_PROJECT COMMAND 'dbt build';

-- To check project status:
-- DESCRIBE DBT PROJECT WEATHER_DB.RAW.WEATHER_DBT_PROJECT;

-- To drop the project (if needed):
-- DROP DBT PROJECT IF EXISTS WEATHER_DB.RAW.WEATHER_DBT_PROJECT;

-- ============================================================================
-- Notes:
-- ============================================================================
-- 1. You need to push your dbt project to a Git repository first
-- 2. The repository must contain: dbt_project.yml, models/, etc.
-- 3. Do NOT include profiles.yml in Git (use dbt_project.yml for config)
-- 4. Snowflake native dbt projects don't use profiles.yml
-- 5. Database/schema configs come from dbt_project.yml +database and +schema
-- 6. Secrets should be stored as Snowflake secrets, not in .env files
-- 7. Alternative: Continue using local dbt with `dbt run` (no Git needed)

