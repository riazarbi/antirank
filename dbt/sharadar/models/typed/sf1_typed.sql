SELECT 
ticker,
dimension,
CAST(strptime(calendardate, '%Y-%m-%d') AS DATE) as calendardate,
CAST(strptime(datekey, '%Y-%m-%d') AS DATE) as datekey,
CAST(strptime(reportperiod, '%Y-%m-%d') AS DATE) as reportperiod,
CAST(strptime(lastupdated, '%Y-%m-%d') AS DATE) as lastupdated,
measure,
value
FROM
{{ ref('stg_sf1_unpivot') }}