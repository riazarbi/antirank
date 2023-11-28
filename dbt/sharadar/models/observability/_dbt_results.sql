SELECT
    log_write_time,
    cast(json_extract_string(log, '$.execution_time') AS numeric) AS execution_time,
    cast(json_extract_string(log, '$.adapter_response.bytes_processed') AS numeric)
    AS bytes_processed,
    json_extract_string(log, '$.node.name') AS node_name,
    json_extract_string(log, '$.node.schema') AS schema_name,
    json_extract_string(log, '$.node.database') AS database_name,
    json_extract_string(log, '$.node.unique_id') AS unique_id,
    json_extract_string(log, '$.adapter_response.job_id') AS bigquery_job,
    concat(
        'https://console.cloud.google.com/bigquery?project=',
        json_extract_string(log, '$.adapter_response.project_id'),
        '&j=bq:',
        json_extract_string(log, '$.adapter_response.location'),
        ':',
        json_extract_string(log, '$.adapter_response.job_id'),
        '&page=queryresults'
    ) AS url,
    cast(json_extract_string(log, '$.adapter_response.bytes_billed') AS numeric)
    / pow(10, 12) AS tebi_bytes_billed,
    cast(json_extract_string(log, '$.adapter_response.bytes_billed') AS numeric)
    / pow(10, 12)
    * 6.25 AS billed_dollar_estimate,
    json_extract_string(log, '$.status') AS status,
    json_extract_string(log, '$.message') AS log_message
FROM
    {{ ref('_dbt_results_json') }}
ORDER BY log_write_time DESC
