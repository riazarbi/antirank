from environment import logging
from dbt.cli.main import dbtRunner, dbtRunnerResult

def eval_dbt_result(res):
    log = logging.setup_logging()

    if res.success:
        log.info("Success")
    else:
        log.info("Fail")
        log.info(f"Exception: {res.exception}")

def run_dbt_command(target: str, command: list):
    
    log = logging.setup_logging()
    log.info("Initialising dbt runner...")
    dbt = dbtRunner()

    log.info("Setting build context...")    
    loglevel = ["--log-level-file", "info"] 
    context = ["--project-dir", "dbt", 
               "--profiles-dir", "dbt", 
               "--target", target]

    log.info(f"cli: dbt {' '.join(loglevel)} {' '.join(command)} {' '.join(context)} ")
    log.info(f"BEGIN dbt logs: \n ")

    res: dbtRunnerResult = dbt.invoke(loglevel + command + context)
    
    log.info(f"END dbt logs \n ")
    return res
