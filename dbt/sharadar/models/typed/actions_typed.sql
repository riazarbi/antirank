SELECT 
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
action, 
ticker,
name,
CAST(value as DOUBLE) AS value,
contraticker,
contraname
FROM
{{ ref('stg_actions') }}