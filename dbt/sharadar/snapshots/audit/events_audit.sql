{% snapshot events_audit %}

{{
    config(
      target_schema='sharadar',
      unique_key="ticker||'-'||date",
      strategy='check',
      check_cols=['eventcodes']
      )
}}

SELECT * FROM {{ ref('events') }}

{% endsnapshot %}