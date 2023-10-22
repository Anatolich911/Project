FROM centos:7

COPY gcloud.repo  /etc/yum.repos.d/

RUN yum install unzip  wget   git telnet  google-cloud-sdk  jq -y   && \

    # below code installs helm 
    curl -O https://get.helm.sh/helm-v3.8.1-linux-amd64.tar.gz && \
	tar xzvf helm-v3.8.1-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/bin/ && \

	
	# below code installs terraform
	curl -O https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip && \
	unzip terraform_0.14.11_linux_amd64.zip && \
	mv terraform /usr/bin/ && \
	
	
	# below code installs kubectl 
	curl -LO https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl && \
	chmod +x kubectl && \
	mv kubectl /usr/bin/ && \

	
	# below code installs packer
	rm -rf /usr/sbin/packer && \
	yum install -y yum-utils && \
	yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
	yum -y install packer && \
	

	# below code installs sonar-scanner
	curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip && \
    unzip sonar-scanner-cli-4.7.0.2747-linux.zip  

    

ENV PATH=$PATH:/sonar-scanner-4.7.0.2747-linux/bin/
