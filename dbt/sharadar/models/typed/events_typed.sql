SELECT
    ticker,
    eventcodes,
    CAST(STRPTIME(date, '%Y-%m-%d') AS DATE) AS date
FROM
    {{ ref('stg_events') }}
