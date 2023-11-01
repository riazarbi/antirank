{% snapshot indicators_audit %}

{{
    config(
      target_schema='sharadar',
      unique_key='id',
      strategy='check',
      check_cols='all',
    )
}}

SELECT "table" ||'-'||indicator AS id, * FROM {{ ref('indicators') }}

{% endsnapshot %}