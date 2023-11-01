# ANTIRANK

Investigating the construction of subtractive equity portfolios

## Data Warehouse

Our research makes use of [Sharadar](https://data.nasdaq.com/publishers/SHARADAR) data. We bulk load relevant sharadar tables daily.

```
bash install_deps.sh
pipenv run src/load_raw.py
cd dbt
pipenv run dbt build --project-dir sharadar 
pipenv run dbt build --project-dir sharadar --target motherduck
```

# Data Tools

- Github Actions with self hosted runners for scheduling
- Motherduck and duckdb for database
- dbt for data transformation
- python for data source extraction