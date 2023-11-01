{% snapshot actions_audit %}

{{
    config(
      target_schema='sharadar',
      unique_key="date||'-'||action||'-'||ticker||'-'||contraticker",
      strategy='check',
      check_cols='all',
    )
}}

SELECT * FROM {{ ref('actions') }}

{% endsnapshot %}