SELECT
table_catalog,
table_schema, 
table_type
FROM
{{ source('information_schema','tables') }}