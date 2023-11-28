SELECT
    ticker,
    CAST(STRPTIME(date, '%Y-%m-%d') AS DATE) AS date,
    CAST(STRPTIME(lastupdated, '%Y-%m-%d') AS DATE) AS lastupdated,
    CAST(ev AS DOUBLE) AS ev,
    CAST(evebit AS DOUBLE) AS evebit,
    CAST(evebitda AS DOUBLE) AS evebitda,
    CAST(marketcap AS DOUBLE) AS marketcap,
    CAST(pb AS DOUBLE) AS pb,
    CAST(pe AS DOUBLE) AS pe,
    CAST(ps AS DOUBLE) AS ps
FROM
    {{ ref('stg_daily') }}
