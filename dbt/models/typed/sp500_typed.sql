SELECT
    action,
    ticker,
    name,
    contraticker,
    contraname,
    note,
    CAST(STRPTIME(date, '%Y-%m-%d') AS DATE) AS date
FROM
    {{ ref('stg_sp500') }}
