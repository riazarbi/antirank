{% snapshot tickers_time_versioned %}

{{
    config(
      target_schema='sharadar',
      unique_key="id",
      strategy='timestamp',
      updated_at='lastupdated'
      )
}}

SELECT "table" ||'-'||permaticker||'-'||ticker AS id, * FROM {{ ref('tickers_typed') }}

{% endsnapshot %}