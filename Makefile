APP := $(notdir $(shell pwd))
IMAGE_TAG := $(APP):latest
GIT_BRANCH := $(shell git branch --show-current)
TIER=dev

.DEFAULT_GOAL := help
NPROCS = $(shell grep -c 'processor' /proc/cpuinfo)

ifeq ($(shell uname -m), arm64)
 DEBIAN_ARCH := aarch64
else
 DEBIAN_ARCH := x86_64
endif

.PHONY: help
help: ## Show available targets
	@printf "These are the available make commands you can run:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@printf "\nAvailable parameters: \n"
	@printf "\033[36mTIER:\033[0m Default [$(TIER)]. Can be dev or prod\n\n" 
	@printf "Example: make dbt-run TIER=prod\n\n"

######## DOCKER COMMAND BUILDER #########

ci_run_prefix := docker run --rm --name $(APP) -e APP=$(APP) --env-file .env  --mount type=bind,source=/data/antirank,target=/data/antirank
local_run_prefix := docker run --rm -it --name $(APP) -e APP=$(APP) --env-file .env --mount type=bind,source=/data/antirank,target=/data/antirank --mount type=bind,source="$(shell pwd)/",target=/app/

run_suffix := -e ENVIRONMENT=$(ENVIRONMENT) -e TIER=$(TIER) -e GIT_BRANCH=$(GIT_BRANCH) 

ifeq ($(USER),)
run :=  $(ci_run_prefix) $(run_suffix)
else
run := $(local_run_prefix)  $(run_suffix)
endif

test_run := $(run) --entrypoint=/bin/bash  $(IMAGE_TAG)

###### BUILD TARGETS #########

.PHONY: newlock
newlock: ## Recreate Pipfile.lock from Pipfile
	touch Pipfile.lock
	docker build --build-arg="BUILD_ENV=nodeps"  --build-arg="DEBIAN_ARCH=$(DEBIAN_ARCH)" -t $(APP):nodeps .
	docker run --rm --name $(APP) --entrypoint=/bin/bash --mount type=bind,source="$(shell pwd)/",target=/app  -e APP=$(APP) $(APP):nodeps install_deps.sh nolock

.PHONY: local-build
local-build: ## Install development dependencies locally
	bash install_deps.sh dev

.PHONY: docker-build
docker-build: ## Build a ready to deploy production image
	docker build --build-arg="DEBIAN_ARCH=$(DEBIAN_ARCH)" -t $(IMAGE_TAG) .

###### TEST TARGETS #########

.PHONY: dbt-lint
dbt-lint: ## Lint dbt models
	pipenv run sqlfluff lint dbt/models --dialect duckdb

.PHONY: dbt-unit-test
dbt-unit-test:  ## Run UNIT tests against target database
	pipenv run dbt test --select "tag:unit-test" --project-dir dbt --profiles-dir dbt  --target $(TIER)

.PHONY: dbt-quality-test
dbt-quality-test:  ## Run QUALITY tests against target database
	pipenv run dbt test --exclude "tag:unit-test" --project-dir dbt --profiles-dir dbt --target $(TIER)

###### LOAD TARGETS #########
.PHONY: ingest-sharadar
ingest-sharadar: ## Ingest sharadar data
	pipenv run ingest_sharadar


###### BUILD TARGETS #########

.PHONY: dbt-run
dbt-run: ## Execute dbt run against target database
	pipenv run dbt run --project-dir dbt --profiles-dir dbt  --target $(TIER)

.PHONY: dbt-snapshot
dbt-snapshot: ## Execute dbt snapshot against target database
	pipenv run dbt snapshot --project-dir dbt --profiles-dir dbt  --target $(TIER)

.PHONY: dbt-build
dbt-build: ## Execute dbt build against target database
	pipenv run dbt build --project-dir dbt --profiles-dir dbt  --target $(TIER)

.PHONY: dbt-docs
dbt-docs: ## Create new documentation html and save to public folder
	pipenv run dbt docs generate --project-dir dbt --profiles-dir dbt  --target $(TIER)

####### DEBUG TARGETS ########

.PHONY: dev
dev: ## Launch an interactive dev environment
	$(test_run)
