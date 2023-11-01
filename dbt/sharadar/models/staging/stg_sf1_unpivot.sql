WITH unp AS (
{{ dbt_utils.unpivot(
  relation=ref('stg_sf1'),
  cast_to='numeric',
  exclude=['ticker', 'dimension', 'calendardate', 'datekey', 'reportperiod', 'lastupdated'],
  field_name='measure',
  value_name='value'
) }} )
SELECT * FROM unp WHERE value IS NOT NULL