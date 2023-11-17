{% macro upload_dbt_results(results, batch_size=50000) %}
{# /* If we are in execute mode */ #}
  {% if execute and results | length > 0%}

  {{ log('Uploading run statistics to database', info=True) }}

{# /* Create a namespace for the query string to avoid scoping issues */ #}
  {% set ns = namespace() %}
{# /* Start with an empty query string */ #}
  {% set ns.batch_query = "" %}
  {% set loops = results | length %} 

{# /* Loop through native dbt results objects */ #}
  {% for res in results -%}
{# /* Convert to dict */ #}
    {%- set res_dict = res.to_dict()  %}
{# /* Remove two troublesome keys (too long / special characters) */ #}
    {%- set _ = res_dict.node.pop('raw_code', None)  %}
    {%- set _ = res_dict.node.pop('compiled_code', None)  %}

{# /* Convert to JSON and strip special characters */ #}
    {%- set res_json = res_dict | tojson |  replace("'", " ")  | replace("\\n", " ") | replace("`", "")| replace("\\", "\\\\")  %}

{# /* Wrap json in '' so we can pass in as string */ #}
    {%- set results_object = ["'", res_json, "'"] | join(" ")  %}
{# /* Construct insert query for this result */ #}
    {%- set results_query = [ "(CURRENT_TIMESTAMP, JSON  ",results_object,")"] | join(" ") %}

{# /* If the batch insert string is empty, replace it with the results_query... */ #}
    {% if ns.batch_query|length == 0 %}
      {% set ns.batch_query = results_query %}
{# /* If the batch insert string is small enough... */ #}
    {% elif ns.batch_query | length < batch_size %}
{# /* Append this current query to the batch insert string */ #}
      {% set ns.batch_query = [ns.batch_query, results_query] | join(", ") %}
{# /* But if the batch insert string is big enough... */ #}
    {% else %}
{# /* Append this current query to the batch insert string */ #}
      {% set ns.batch_query = [ns.batch_query, results_query] | join(", ") %}
{# /* Log the loop... */ #}
      {{ log('Running insert operation on loop ' ~ loop.index ~ '/' ~ loops, info=True) }}
{# /* Run the batch insert query... */ #}
      {%- call statement('upload', fetch_result=False) -%}
       INSERT INTO {{ target.schema }}._dbt_results_json (log_write_time, log) VALUES {{ ns.batch_query }}
      {%- endcall -%}
{# /* And clear it back to an empty string */ #}
      {% set ns.batch_query = "" %}
    {% endif %}

{# /* Once you've worked through all the objects... */ #}
  {% endfor %}

{# /* Insert the last batch query string */ #}
  {{ log('Running final insert operation', info=True) }}

  {%- call statement('upload', fetch_result=False) -%}
       INSERT INTO {{ target.schema }}._dbt_results_json (log_write_time, log) VALUES {{ ns.batch_query }}
  {%- endcall -%}

  {% endif %} 

{% endmacro %}

