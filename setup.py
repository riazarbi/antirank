from setuptools import setup, find_packages
import json

# Use the 'pipenv lock -r' command to extract dependencies from Pipfile.lock
with open('Pipfile.lock') as f:
    pipfile_lock_data = json.load(f)

install_requires = [package_name + package_data['version'] for package_name, package_data in pipfile_lock_data['default'].items()]

setup(
    name='antirank',
    version='0.1',
    packages=find_packages(where='python'),
    package_dir={'': 'python'},
    install_requires=install_requires,
    entry_points={
        'console_scripts': [
            'ingest_sharadar = ingest.sharadar:entry_point',
        ],
    },
)
