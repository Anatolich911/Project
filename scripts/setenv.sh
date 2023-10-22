#!/bin/bash

# Set current folder
DIR=$(pwd)

### Set color
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


#########################################################################################################
# Check if the configurations.tfvars file is created
if [ -f ~/project_infrastructure/0.account_setup/configurations.tfvars ]
then 
  echo ${green} "Please continue" ${reset}
else 
  echo """
  
          ${red}Please create this file first ~/project_infrastructure/0.account_setup/configurations.tfvars ${reset}
          
  """
  return
fi

#########################################################################################################
project_id=`cat ~/project_infrastructure/0.account_setup/configurations.tfvars | grep project_id | awk '{print $3}' | tr -d '"'`
if  [ -z  $project_id ];
then 
  echo """
      ${red}Did you add project name in ~/project_infrastructure/0.account_setup/configurations.tfvars  ${reset}
      
      project_id=YOUR_project_id
      """
  return
else
  echo ${green} "Project ID is given" ${reset}
fi




#########################################################################################################
bucket_name=`cat ~/project_infrastructure/0.account_setup/configurations.tfvars | grep bucket_name | awk '{print $3}' | tr -d '"'`
if  [ -z  $bucket_name ];
then 
  echo """
      ${red}Did you add bucket_name  in ~/project_infrastructure/0.account_setup/configurations.tfvars  ${reset}
      
      bucket_name=YOUR_bucket_name
      """
  return
else
  echo ${green} "Bucket name is given" ${reset}
fi



#########################################################################################################
PACKAGE_NAME="tfenv"
if ! which $PACKAGE_NAME &> /dev/null;
then 
  echo """
      ${red}
      Please install tfenv before moving forward
        Instructions are here:
          git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
          echo 'export PATH="\$HOME/.tfenv/bin:\$PATH"' >> ~/.bash_profile
          source ~/.bash_profile 
          tfenv install TERRAFORM_VERSION  
          tfenv use TERRAFORM_VERSION
        ${reset}
  """
  return
else 
  echo ${green} "tfenv is installed please continue" ${reset}
fi

#########################################################################################################



gcloud config set project $project_id

################################################################################################################
#                                                   
#
#            This line below configures hashicorp vault cli
#
################################################################################################################
if [ ! -f ~/project_infrastructure/bin/vault ];
then 
  echo """

${green}Configuring vault cli ${reset} 
      
      """
  wget -q https://releases.hashicorp.com/vault/1.14.0/vault_1.14.0_linux_amd64.zip -P ~/project_infrastructure/bin
  unzip -q ~/project_infrastructure/bin/vault_1.14.0_linux_amd64.zip -d ~/project_infrastructure/bin/
  rm -rf ~/project_infrastructure/bin/vault_1.14.0_linux_amd64.zip
  export PATH=$PATH:~/project_infrastructure/bin
  echo """

${green}vault is ready ${reset}

      """
fi



cat << EOF > "$DIR/backend.tf"
terraform {
  backend "gcs" {
    bucket = "${bucket_name}"
    prefix = "/dev`pwd`"
  }
}
EOF
cat "$DIR/backend.tf"

export GOOGLE_PROJECT="$project_id"


terraform init -reconfigure


echo """
      Your Project ID: ${green}$project_id${reset}
      
      
      
      ${green}You are good to go !!! ${reset}

      
"""
