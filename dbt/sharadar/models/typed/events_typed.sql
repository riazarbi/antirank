SELECT 
ticker,
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
eventcodes
FROM
{{ ref('stg_events') }}