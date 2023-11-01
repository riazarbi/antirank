{% snapshot metrics_time_versioned %}

{{
    config(
      target_schema='sharadar',
      unique_key="ticker||'-'||date||'-'||metric",
      strategy='timestamp',
      updated_at='lastupdated'
      )
}}

SELECT * FROM {{ ref('metrics_typed') }}

{% endsnapshot %}