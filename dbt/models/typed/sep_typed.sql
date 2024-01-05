SELECT
    ticker,
    CAST(STRPTIME(date, '%Y-%m-%d') AS DATE) AS date,
    CAST(STRPTIME(lastupdated, '%Y-%m-%d') AS DATE) AS lastupdated,
    CAST(open AS DOUBLE) AS open,
    CAST(high AS DOUBLE) AS high,
    CAST(low AS DOUBLE) AS low,
    CAST(close AS DOUBLE) AS close,
    CAST(volume AS DOUBLE) AS volume,
    CAST(closeadj AS DOUBLE) AS closeadj,
    CAST(closeunadj AS DOUBLE) AS closeunadj
FROM
    {{ ref('stg_sep') }}
