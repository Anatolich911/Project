#!/bin/bash
gcloud auth configure-docker  us-central1-docker.pkg.dev
gcloud artifacts locations list

# bash ../scripts/gcr_login.sh 



# Test push 
# docker pull wordpress
# docker image tag wordpress us-central1-docker.pkg.dev/$GOOGLE_PROJECT/artemis/wordpress:1.0.0
# docker push us-central1-docker.pkg.dev/$GOOGLE_PROJECT/artemis/wordpress:1.0.0


# Steps to Build and image and push
# Step 1 
#    Change the branch 
#        git checkout 2.0.0


# Step 2
#    Build Image and tag 
#       docker build -t us-central1-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/artemis/artemis:2.0.0   .


# Step 3 
#    Push the image 
#       docker push us-central1-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/artemis/artemis:2.0.0


# task, please push versions upto 10