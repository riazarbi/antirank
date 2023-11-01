SELECT
ticker,
 dimension, 
calendardate,
datekey,
reportperiod,
lastupdated,
  {{ dbt_utils.pivot(
      'measure',
      dbt_utils.get_column_values(ref('sf1_typed'), 'value')
  ) }}
from {{ ref('sf1_typed') }}
GROUP BY 
ticker,
dimension, 
calendardate,
datekey,
reportperiod,
lastupdated