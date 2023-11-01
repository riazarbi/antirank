SELECT 
ticker,
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
CAST(strptime(lastupdated, '%Y-%m-%d') AS DATE) as lastupdated,
metric,
value
FROM
{{ ref('stg_metrics_unpivot') }}