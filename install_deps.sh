#!/usr/bin/env bash
set -euoE pipefail

PIPENV_INSTALL_ARGS=${1:-noarg}

echo Installing python deps with args: $PIPENV_INSTALL_ARGS

isDocker(){
    local cgroup=/proc/1/cgroup
    test -f $cgroup && [[ "$(<$cgroup)" = *:cpuset:/docker/* ]]
}

isDockerBuildkit(){
    local cgroup=/proc/1/cgroup
    test -f $cgroup && [[ "$(<$cgroup)" = *:cpuset:/docker/buildkit/* ]]
}

isDockerContainer(){
    [ -e /.dockerenv ]
}

if isDockerBuildkit || (isDocker && ! isDockerContainer)
then
APP_ROOT=/app
PATH=$PATH:/home/appuser/.local/bin
else
APP_ROOT=$PWD
PATH=$PATH:$APP_ROOT/.venv/bin
fi

echo Using app root directory $APP_ROOT

VIRTUAL_ENV=$APP_ROOT/.venv

rm -rf $APP_ROOT/.venv $APP_ROOT/.local

pip install --upgrade pip 
pip --quiet --no-cache-dir install pipenv 
virtualenv ${VIRTUAL_ENV} 

if [ $PIPENV_INSTALL_ARGS == "noarg" ]
then 
    PIPENV_VERBOSITY=-1 pipenv install
    echo Installing duckdb cli
    wget "https://github.com/duckdb/duckdb/releases/download/v0.9.2/duckdb_cli-linux-amd64.zip" -O temp.zip
    unzip temp.zip
    rm temp.zip
    mv duckdb $VIRTUAL_ENV/bin
    chmod +x $VIRTUAL_ENV/bin/duckdb 
    echo Installing local python packages
    pipenv run pip install .
    echo Installing dbt dependencies
    APP_ROOT=$APP_ROOT dbt deps --project-dir=$APP_ROOT/dbt --profiles-dir=$APP_ROOT/dbt
elif [ $PIPENV_INSTALL_ARGS == "nodeps" ]
then
    echo No dependencies installed.
elif [ $PIPENV_INSTALL_ARGS == "nolock" ]
then
    rm -rf Pipfile.lock
    PIPENV_VERBOSITY=-1 pipenv install
    echo Installing duckdb cli
    wget "https://github.com/duckdb/duckdb/releases/download/v0.9.2/duckdb_cli-linux-amd64.zip" -O temp.zip
    unzip temp.zip
    rm temp.zip
    mv duckdb $VIRTUAL_ENV/bin
    chmod +x $VIRTUAL_ENV/bin/duckdb 
    echo Installing local python packages
    pipenv run pip install .
    echo Installing dbt dependencies
    APP_ROOT=$APP_ROOT dbt deps --project-dir=$APP_ROOT/dbt --profiles-dir=$APP_ROOT/dbt
elif [ $PIPENV_INSTALL_ARGS == "dev" ]
then
    PIPENV_VERBOSITY=-1 pipenv install -d
    echo Installing duckdb cli
    wget "https://github.com/duckdb/duckdb/releases/download/v0.9.2/duckdb_cli-linux-amd64.zip" -O temp.zip
    unzip temp.zip
    rm temp.zip
    mv duckdb $VIRTUAL_ENV/bin
    chmod +x $VIRTUAL_ENV/bin/duckdb 
    echo Installing local python packages
    pipenv run pip install -e .
    echo Installing dbt dependencies
    APP_ROOT=$APP_ROOT dbt clean --project-dir=$APP_ROOT/dbt --profiles-dir=$APP_ROOT/dbt
    APP_ROOT=$APP_ROOT dbt deps --project-dir=$APP_ROOT/dbt --profiles-dir=$APP_ROOT/dbt
fi
