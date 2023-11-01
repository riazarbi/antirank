SELECT 
ticker,
CAST(strptime(date, '%Y-%m-%d') AS DATE) as date,
CAST(strptime(lastupdated, '%Y-%m-%d') AS DATE) as lastupdated,
CAST(open AS DOUBLE) as open,
CAST(high AS DOUBLE) as high,
CAST(low AS DOUBLE) as low,
CAST(close AS DOUBLE) as close,
CAST(volume AS DOUBLE) as volume,
CAST(closeadj AS DOUBLE) as closeadj,
CAST(closeunadj AS DOUBLE) as closeunadj
FROM
{{ ref('stg_sep') }}