SELECT 
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
action,
ticker,
name,
contraticker,
contraname,
note
FROM
{{ ref('stg_sp500') }}