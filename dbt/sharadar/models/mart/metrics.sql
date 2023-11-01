SELECT
ticker,
 "date", 
 lastupdated,
  {{ dbt_utils.pivot(
      'metric',
      dbt_utils.get_column_values(ref('metrics_typed'), 'value')
  ) }}
from {{ ref('metrics_typed') }}
GROUP BY 
ticker,
"date",
lastupdated