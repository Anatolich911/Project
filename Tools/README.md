# Instructions 
### You can add any tool in this docker image, and build the image. Just update Dockerfile

### Configure Project ID 
```
source ../scripts/setenv.sh  
```
### Build Image 
```
  docker build -t   tools:latest     . 
```

### Tag Image 
```
  docker  image  tag  tools:latest us-central1-docker.pkg.dev/$GOOGLE_PROJECT/tools/tools:latest
```

### Authenticate 
```
	gcloud auth configure-docker  us-central1-docker.pkg.dev
```

### Push image 
```
   docker push us-central1-docker.pkg.dev/$GOOGLE_PROJECT/tools/tools:latest
```