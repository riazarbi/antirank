{% snapshot sp500_audit %}

{{
    config(
      target_schema='sharadar',
      unique_key="date||'-'||ticker",
      strategy='check',
      check_cols='all'
      )
}}

SELECT * FROM {{ ref('sp500_typed') }}

{% endsnapshot %}