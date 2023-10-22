### This repo is used to deploy namespaces

---
### Usage: 
---

#### 1. Configure backend
```
source  ../scripts/setenv.sh
```
#### 2. Create 
```
terraform apply    -var-file ~/project_infrastructure/0.account_setup/configurations.tfvars 
```


---
## Verification Proccess.


### Prometheus 
```
kubectl get pods -n prometheus 
kubectl get ingress -n prometheus
```

### Grafana 
```
kubectl get pods -n grafana 
kubectl get ingress -n grafana
```

### cert-manager 
```
kubectl get pods -n cert-manager 
```

### metrics-server
```
kubectl get pods -n kube-system
```

### External DNS 
```
kubectl get pods -n default 
On Console >> Cloud DNS >> hosted-zone >> Check records
```


### Check logs of external-dns
```
kubectl get pods -n external-dns 
kubectl logs POD_NAME -n external-dns
```

----
### Troubleshooting cert-manager
#### Sometimes when you visit the URL, it complains that certificate is not valid. Run below command and verify it is referring to the right clusterissuer
```
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```
---
### When above command ran, you should check for certificate readiness, and validity. 


----
### Troubleshooting certificate issue (https://)
#### Usually this issue happens when certificate is not ready. When you run below command it tells if certificate is Ready=True or Ready=False. Start by running below command. When you run 
```
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```

If the certificate request is not ready like below
```
certificaterequest.cert-manager.io/grafana-tls-zz84p   True                False    letsencrypt-prod  
```
#### then the error is related to ClusterIssuer. 
#### Steps two fix it
1. run 
```
kubectl get clusterissuer
kubectl describe clusterissuer
kubectl get certificaterequest -n NAMESPACE
kubectl certificaterequest grafana-tls-zz84p  -n NAMESPACE
```
#### if the clusterissuer is not working, you can rebuild it. 
```
cd 2.tools-setup
terraform state list 
terraform taint module.lets-encrypt.helm_release.helm_deployment
source ../scripts/setenv.sh
terraform apply -var-file ../0.account_setup/configurations.tfvars
```


### Fix argocd issue
#### argocd was failing due to certificate issue the following steps fixed it. We had to remove custom resource definition and redeploy with proper naming 
```
kubectl get CustomResourceDefinition | grep argo
kubectl delete CustomResourceDefinition applications.argoproj.io 
kubectl delete CustomResourceDefinition applicationsets.argoproj.io
kubectl delete CustomResourceDefinition appprojects.argoproj.io
cd 2.tools-setup
source ../scripts/setenv.sh 
terraform apply -var-file ~/project_infrastructure/0.account_setup/configurations.tfvars -auto-approve
 ```



# Working with Argocd CLI
#### Main documentation 
```
https://argo-cd.readthedocs.io/en/release-1.8/user-guide/commands/argocd_app_create/
```
## Working with clusters
#### Login to argocd 
```
argocd login ARGOCD_URL
```
#### List existing clusters
```
argocd cluster list 
```
####  Add new cluster 
```
kubectl config get-contexts -o name
argocd cluster add NAME
```
---
## Working with apps
#### List apps
```
argocd app -h
argocd app list
argocd app get APPNAME
```

## Working with sosivio
#### This application is used to monitor, and give recommendations about the: 
- health of kubernetes
- worker nodes of kubernetes
- pods of kubernetes 


#### Get the Load Balancer IP to connect 
```
kubectl get svc -n sosivio
```

#### User name
```
admin
```

#### in make file, there is command to get the password




### Contributing to this code 
#### Step 1  Create Branch 
```
git checkout -b Branch_Name
```
#### Step 2  Do the changes 
#### Step 2.1 Configure your username 
```
git config --global user.name GITHUB_USERNAME
git config --global user.email  GITHUB_EMAIL
```
#### Step 3  Push 
#### Step 4  Create Pull Request, Send to Slack 



### Contributing to this code
#### Step 1 Create Branch
```
git checkout -b Branch_Name
```
#### Step 2 Do the changes
#### Step 2.1 Configure your username
```
 git config --global user.name GITHUB_USERNAME
 git config --global user.email GITHUB_EMAIL
```
#### Step 3 Push
#### Step 4 Create Pull Request, Send to Slack



### Access to Sosivio Dashboard (Username and Password)
#### Step 1  Find the External-IP
````
cd  project_infrastructure 
kubectl get services -A  
Find the External_IP of service name dashboard-lb
Copy External_IP and paste it on your browser
```
#### Step 2 Find the Username and Password
```
Username: admin
Password: 
Enter this command to get the password: 
kubectl get secret -n sosivio sosivio-admin-otp -o jsonpath=‘{.data.password}’ | base64 -d

For more info go to this website:
https://docs.sosiv.io/quickstart/
```


### Troubleshooting namespace that stuck in terminating state
Sometimes a namespace gets stuck in terminating state and does not let you run terraform commands. 
In this kind of situations, you have to delete the terminating namespace, and kubectl command cannot do that.
Run the following command to fix it
```
(
NAMESPACE=YOUR_NAMESPACE_NAME
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
)
```

This cleans up the namespace stuck in terminating stage and lets you run the terraform commands
