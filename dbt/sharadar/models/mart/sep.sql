SELECT
ticker,
 "date", 
 lastupdated,
  {{ dbt_utils.pivot(
      'metric',
      dbt_utils.get_column_values(ref('sep_typed'), 'value')
  ) }}
from {{ ref('sep_typed') }}
GROUP BY 
ticker,
"date",
lastupdated