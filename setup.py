from setuptools import setup, find_packages

setup(
    name='antirank',
    version='0.1',
    packages=find_packages(where='python'),
    package_dir={'': 'python'},
    install_requires=[
        'duckdb'
    ],
    entry_points={
        'console_scripts': [
            'ingest_sharadar = ingest.sharadar:entry_point',
        ],
    },
)