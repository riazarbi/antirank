SELECT 
ticker,
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
CAST(strptime(lastupdated, '%Y-%m-%d') AS DATE) as lastupdated,
CAST(ev AS DOUBLE) as ev,
CAST(evebit AS DOUBLE) as evebit,
CAST(evebitda AS DOUBLE) as evebitda,
CAST(marketcap AS DOUBLE) as marketcap,
CAST(pb AS DOUBLE) as pb,
CAST(pe AS DOUBLE) as pe,
CAST(ps AS DOUBLE) as ps,
FROM
{{ ref('stg_daily') }}