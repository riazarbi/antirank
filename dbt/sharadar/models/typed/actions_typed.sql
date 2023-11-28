SELECT
    action,
    ticker,
    name,
    contraticker,
    contraname,
    CAST(STRPTIME(date, '%Y-%m-%d') AS DATE) AS date,
    CAST(value AS DOUBLE) AS value
FROM
    {{ ref('stg_actions') }}
