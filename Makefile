dev:
	@rm -rf .terraform
	@terraform init
	@terraform apply -auto-aprove -vars-file=env-dev/main.tfvars

prod:
	@rm -rf .terraform
	@terraform init
	@terraform apply -auto-aprove -vars-file=env-prod/main.tfvars