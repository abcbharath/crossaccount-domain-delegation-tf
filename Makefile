SHELL := /bin/bash

REGION ?= 

# The Environment, i.e dev/qa/prod
ENV ?= " "

# The IAM_ROLE In CI Environment
IAM_ROLE ?= " "

# cluster color
CLUSTER_COLOR ?= $(shell aws configure get deploy-color)

# The AWS account
ACCOUNT ?= $(shell aws configure get account)

VAR_FILE ?= vars/$(ENV)-$(REGION).tfvars

create: clean _tg_plan _tg_apply clean

plan: clean _tg_plan 

upgrade: clean _tg_init _tg_apply clean

delete: _tf_destroy clean

no_prompt_delete:  _tf_init _tf_delete _clean

sleep:
	@sleep 60

clean: _clean

_prompt_delete:
	@echo $(shell stty -echo; read -p "YOU ARE ABOUT TO DELETE CLUSTER: $(CURRENT_CLUSTER). PRESS ENTER TO CONTINUE" pwd; stty echo; echo $$pwd)

_tg_init:
	@echo "Initializing terragrunt"
	@terragrunt init

_tg_plan: _tg_init
	@echo "Planning: Generating manifests for CrossAccount Domain Delegation"
	@echo "${VAR_FILE}"
	@terragrunt plan \
		-var-file="${VAR_FILE}"

_tg_apply: _tg_plan
	@echo "Running Terragrunt Apply"
	@echo "${VAR_FILE}"
	@terragrunt apply \
		-var-file="${VAR_FILE}" \
		-auto-approve

_tg_destroy: _tg_init
	@echo "Running Terragrunt Destroy"
	@echo "${VAR_FILE}"
	@terragrunt destroy \
		-var-file="${VAR_FILE}" \
		-auto-approve

_tg_plan_iam: _clean _tg_init 
	@echo "Planning: Generating manifests for CrossAccount Domain Delegation"
	@echo "${VAR_FILE}"
	@terragrunt plan \
		-var-file="${VAR_FILE}" \
		--terragrunt-iam-role "${IAM_ROLE}"

_tg_apply_iam: _tg_plan_iam
	@echo "Generating manifests for CrossAccount Domain Delegation"
	@echo "${VAR_FILE}"
	@terragrunt apply \
		-var-file="${VAR_FILE}" \
		-auto-approve \
		--terragrunt-iam-role "${IAM_ROLE}"

_tg_destroy_iam: _tg_init
	@echo "${VAR_FILE}"
	@terragrunt destroy \
		-var-file="${VAR_FILE}" \
		-auto-approve \
		--terragrunt-iam-role "${IAM_ROLE}"

_clean:
	@rm -rf .terragrunt || true
	@rm -rf .terraform || true

_set_profile:
	@export AWS_PROFILE="${ACCOUNT}"
	@echo ${AWS_PROFILE}

list:
	@echo "List of available targets:"
	@sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'make\[1\]' | grep -v 'Makefile' | sort"

_tf_init_cli_options:
	@terraform init -backend=true \
    	-backend-config bucket={s3 bucket name} \
        -backend-config key=path/${REGION}/${ENV}/terraform.tfstate \
        -backend-config region=${REGION} \
        -backend-config dynamodb_table={DynamoDBname}

_tf_plan_cli_options: 
	@echo "Running Plan"
	@terraform plan \
		-var-file="${VAR_FILE}"

_tf_apply_cli_options: _tf_init_cli_options _tf_plan_cli_options
	@echo "Running apply"
	@terraform apply -var-file="${VAR_FILE}" --auto-approve

_tf_destroy_cli_options: _tf_init_cli_options _tf_plan_cli_options
	@echo "Running Destroy"
	@terraform destroy \
		-var-file="${VAR_FILE}" \
		--auto-approve	