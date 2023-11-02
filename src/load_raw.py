import json
import sys
import time
import os
from urllib import request
import zipfile
import logging
import shutil
import duckdb


def entry_point():
    logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(message)s",
                    datefmt="%Y-%m-%d")
    log = logging.getLogger()

    log.info("Processing static parameters...")
    tables = ["SF1", "TICKERS", "INDICATORS", "EVENTS", "DAILY", "SP500", "ACTIONS", "METRICS", "SEP"]
    api_key = os.environ['nasdaq_token']
    motherduck_token=os.environ['motherduck_token']
    download_dir = '.raw/download'
    unzip_dir = '.raw/unzipped'

    log.info("Cleaning out data folders...")
    clean_folders([download_dir, unzip_dir])
  
    for table in tables:  
        destFileRef = '%s/%s.csv.zip' % (download_dir, table) 
        url = 'https://www.quandl.com/api/v3/datatables/SHARADAR/%s.json?qopts.export=true&api_key=%s' % (table, api_key)
        log.info(f"Bulk fetching {destFileRef}...")
        bulk_fetch(url=url, destFileRef=destFileRef)
        log.info(f"Unzipping {destFileRef} to {unzip_dir}")
        os.makedirs(unzip_dir, exist_ok=True)
        unzip_tables(download_dir, table, unzip_dir)
        log.info(f"Loading {table} to dev...")
        load_duckdb('/data/dev.duckdb', table, unzip_dir)
        log.info(f"Loading {table} to prod...")
        load_duckdb('/data/prod.duckdb', table, unzip_dir)
        #log.info(f"Loading {table} to motherduck...")
        #load_duckdb(f'md:antirank?motherduck_token={motherduck_token}', table, unzip_dir)
        
def clean_folders(directory_list):
  for dir in directory_list:
    os.makedirs(dir, exist_ok=True)
    shutil.rmtree(dir)
    os.makedirs(dir)
  

def bulk_fetch(url, destFileRef):
    logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(message)s",
                    datefmt="%Y-%m-%d")
    log = logging.getLogger()
    
    fn = request.urlopen

    valid = ['fresh','regenerating']
    invalid = ['generating']
    status = ''
  
    while status not in valid:
      Dict = json.loads(fn(url).read())
      last_refreshed_time = Dict['datatable_bulk_download']['datatable']['last_refreshed_time']
      status = Dict['datatable_bulk_download']['file']['status']
      link = Dict['datatable_bulk_download']['file']['link']
      log.info(f"Bulk download status: {status}...")
      if status not in valid:
        log.info(f"Waiting 60 seconds...\n")
        time.sleep(60)

    log.info(f'Fetching from link...')
    zipString = fn(link).read()
    f = open(destFileRef, 'wb')
    f.write(zipString)
    f.close()
    log.info(f'Saved to {destFileRef}')


def unzip_tables(download_dir, table, unzip_dir):
    with zipfile.ZipFile('%s/%s.csv.zip' % (download_dir, table), 'r') as zip_ref:
      zip_ref.extractall('%s/%s' % (unzip_dir, table))


def load_duckdb(db, table, csv_root_dir):
  with duckdb.connect(db) as con:
    con.sql(f"CREATE SCHEMA IF NOT EXISTS raw")
    con.sql(f"CREATE OR REPLACE TABLE raw.{table} AS (SELECT * FROM read_csv_auto('{csv_root_dir}/{table}/*.csv', all_varchar=true, header=true))")


if __name__ == '__main__':
    entry_point()