SELECT
ticker, "date", lastupdated,
  {{ dbt_utils.pivot(
      'metric',
      dbt_utils.get_column_values(ref('daily_typed'), 'value')
  ) }}
from {{ ref('daily_typed') }}
GROUP BY 
ticker,
"date",
lastupdated