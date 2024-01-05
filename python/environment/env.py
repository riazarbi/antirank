import argparse
import os

def process_args():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--target',
        required=False,
        default=os.environ.get('TARGET', 'dev'),
        choices=['dev', 'prod', 'motherduck'],
    )
    
    parser.add_argument(
        "--dbt",
        default="debug",
        type=str  
    )
    
    return parser.parse_args()
