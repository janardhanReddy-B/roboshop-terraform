dev:
	@rm -rf .terraform
	@terraform init -backend-config=env-dev/state.tfvars
	@terraform apply -auto-aprove -vars-file=env-dev/main.tfvars

prod:
	@rm -rf .terraform
	@terraform init -backend-config=env-prod/state.tfvars
	@terraform apply -auto-aprove -vars-file=env-prod/main.tfvars