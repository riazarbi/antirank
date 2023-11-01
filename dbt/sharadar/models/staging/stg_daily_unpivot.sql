WITH unp AS (
  {{ dbt_utils.unpivot(
  relation=ref('stg_daily'),
  cast_to='numeric',
  exclude=['ticker', 'date', 'lastupdated'],
  field_name='metric',
  value_name='value'
) }} )
SELECT * FROM unp WHERE value IS NOT NULL
