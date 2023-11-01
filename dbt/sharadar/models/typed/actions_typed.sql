SELECT 
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
action, 
ticker,
name,
CAST(value as NUMERIC) AS value,
contraticker,
contraname
FROM
{{ ref('stg_actions') }}