# ANTIRANK

Investigating the construcion of subtractive equity portfolios

```
bash install_deps.sh
pipenv run src/load_raw.py
cd dbt
pipenv run dbt build --project-dir sharadar 
pipenv run dbt build --project-dir sharadar --target motherduck
```