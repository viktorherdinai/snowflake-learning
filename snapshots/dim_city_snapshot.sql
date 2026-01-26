{% snapshot dim_city_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='city',
      strategy='check',
      check_cols=['latitude', 'longitude', 'country']
    )
}}

SELECT * FROM {{ ref('dim_city') }}

{% endsnapshot %}

