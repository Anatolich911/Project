# Builds all tools 
b:
		terraform apply -var-file ~/project_infrastructure/0.account_setup/configurations.tfvars --auto-approve

# Find out list of pods in each worker node
count-pods-in-nodes:
	for node in $$(kubectl get nodes | awk '{if (NR!=1) {print $$1}}'); do echo ""; echo "Checking $${node}..."; kubectl describe node $${node} | grep "Non-terminated" ; done


get-argo-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	
get-sosivio-password:
	kubectl get secret -n sosivio sosivio-admin-otp -o jsonpath='{.data.password}' | base64 -d
