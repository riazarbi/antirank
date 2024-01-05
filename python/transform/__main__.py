from transform.utils import run_dbt_command, eval_dbt_result
from environment import env, logging


def main():
    log = logging.setup_logging()
    args = env.process_args()
    log.info(f"Args: {args}")     

    dbt_cmd = args.dbt.split() if args.dbt else []
    result = run_dbt_command(args.target, dbt_cmd)
    eval_dbt_result(result)

if __name__ == "__main__":
    main()
