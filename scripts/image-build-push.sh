#!/bin/bash

# Usage:
#   export ACR_NAME=<string>        required    the name of the ACR registry resource
#   export REGISTRY=<string>        optional    the login server URI for the registry
#   export IMAGE=<string>           required    the fully qualified (with registry and commit tag) image "name" to be pushed
#   export PROJECT_CONTEXT=<string> required    the path to the project-specific directory for docker context

if [[ -z "$REGISTRY" ]]; then
  REGISTRY=$(echo "$ACR_NAME.azurecr.io" | tr '[:upper:]' '[:lower:]')
fi

echo "Logging in to $REGISTRY"
TOKEN=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
ACR_USER=00000000-0000-0000-0000-000000000000

echo $TOKEN | oras login $REGISTRY -u $ACR_USER --password-stdin

docker build -t $IMAGE $PROJECT_CONTEXT
docker push $IMAGE
FULL_REPO_DIGEST=$(docker image inspect --format='{{index .RepoDigests 0}}' $IMAGE)
IMAGE_DIGEST=$(echo $FULL_REPO_DIGEST | sed -e 's/^.*@/ /' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//') # this removes everything up to the @ and trims whitespace

if [[ -n "$BUILD_SOURCESDIRECTORY" ]]; then

  echo "##vso[task.setvariable variable=imageDigest;]$IMAGE_DIGEST"

elif [[ -n "$GITHUB_ENV" ]]; then

  echo "IMAGE_DIGEST=$IMAGE_DIGEST" >> $GITHUB_ENV

fi