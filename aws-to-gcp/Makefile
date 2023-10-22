b:
	bash ../scripts/setenv.sh && \
	terraform init -upgrade && \
	terraform apply -var-file ~/project_infrastructure/0.account_setup/configurations.tfvars --auto-approve
d:
	bash ../scripts/setenv.sh && \
	terraform init -upgrade && \
	terraform destroy -var-file ~/project_infrastructure/0.account_setup/configurations.tfvars --auto-approve
