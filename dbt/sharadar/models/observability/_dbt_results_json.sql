{{
  config(
    materialized = 'incremental',
    unique_key = 'log_write_time',
    partition_by = {
      "field": "log_write_time",
      "data_type": "timestamp",
      "granularity": "day"
    },
    partition_expiration_days = 30
  )
}}

with empty_table as (
    select
        cast(null as TIMESTAMP) as log_write_time,
        cast(null as JSON) as log
)

select * from empty_table
-- This is a filter so we will never actually insert these values
where 1 = 0
