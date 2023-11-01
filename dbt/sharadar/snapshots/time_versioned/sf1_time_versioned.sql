{% snapshot sf1_time_versioned %}

{{
    config(
      target_schema='sharadar',
      unique_key="ticker||'-'||dimension||'-'||datekey",
      strategy='timestamp',
      updated_at='lastupdated'
      )
}}

SELECT * FROM {{ ref('sf1') }}

{% endsnapshot %}