#!/usr/bin/env bash
set -euoE pipefail

PIPENV_INSTALL_ARGS=${1:-noarg}

echo Installing python deps with args: $PIPENV_INSTALL_ARGS

VIRTUAL_ENV=.venv

rm -rf .venv 

pip install --upgrade pip 
pip --quiet --no-cache-dir install pipenv 
virtualenv ${VIRTUAL_ENV} 

if [ $PIPENV_INSTALL_ARGS == "noarg" ]
then 
    PIPENV_VERBOSITY=-1 pipenv install
    echo Installing dbt dependencies
    pipenv run dbt deps
elif [ $PIPENV_INSTALL_ARGS == "nodeps" ]
then
    echo No dependencies installed.
elif [ $PIPENV_INSTALL_ARGS == "nolock" ]
then
    rm -rf Pipfile.lock
    PIPENV_VERBOSITY=-1 pipenv install
    echo Installing dbt dependencies
    pipenv run dbt deps
elif [ $PIPENV_INSTALL_ARGS == "dev" ]
then
    PIPENV_VERBOSITY=-1 pipenv install -d
    echo Installing dbt dependencies
    pipenv run dbt clean
    pipenv run dbt deps 
fi