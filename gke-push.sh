#! /bin/bash

# Google Container Registry
PROJECT_ID=$(curl -s 'http://metadata/computeMetadata/v1/project/project-id' -H 'Metadata-Flavor: Google')
erb Dockerfile.erb > Dockerfile
docker build -t ${PROJECT_NAME}:${PROJECT_VERSION} .
docker tag -f ${PROJECT_NAME}:${PROJECT_VERSION} asia.gcr.io/${PROJECT_ID}/${PROJECT_NAME}:${PROJECT_VERSION}
gcloud docker push asia.gcr.io/${PROJECT_ID}/${PROJECT_NAME}:${PROJECT_VERSION}