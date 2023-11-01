{% snapshot sf1_time_versioned %}

{{
    config(
      target_schema='sharadar',
      unique_key="ticker||'-'||dimension||'-'||datekey||'-'||measure",
      strategy='timestamp',
      updated_at='lastupdated'
      )
}}

SELECT * FROM {{ ref('sf1_typed') }}

{% endsnapshot %}