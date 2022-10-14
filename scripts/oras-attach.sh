#!/bin/bash

# Usage:
# export ACR_NAME=<string>         required    the ACR resource name
# export IMAGE=<string>            required    the image to which this artifact will be attached
# export ARTIFACT=<string>         required    the file path of the artifact to be attached
# export MEDIA_TYPE=<string>       required    the media type of the file

# Both of these variables will be set to reasonable defaults if not provided
# export REGISTRY=<string>         optional    the login server URI for ACR registry
# export ARTIFACT TYPE             optional    the artifact type; formatted akin to an IANA media type to provide context to what the artifact is


if [[ -z "$REGISTRY" ]]; then
  REGISTRY=$(echo "$ACR_NAME.azurecr.io" | tr '[:upper:]' '[:lower:]')
fi

echo "Logging in to $REGISTRY"
TOKEN=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
ACR_USER=00000000-0000-0000-0000-000000000000

echo $TOKEN | oras login $REGISTRY -u $ACR_USER --password-stdin

if [[ -z $ARTIFACT_TYPE ]]; then
  case $MEDIA_TYPE in

    application/spdx+json)
      ARTIFACT_TYPE=org.example.sbom.v0
      ;;
    application/sarif+json)
      ARTIFACT_TYPE=org.example.sarif.v0
      ;;
  esac
fi

ORAS_OUTPUT=$(oras attach $IMAGE $ARTIFACT:$MEDIA_TYPE --artifact-type $ARTIFACT_TYPE)

DIGEST_VALUE=$(echo "$ORAS_OUTPUT" | grep -o -P '(?<=Digest: )sha256:\w*') # this should be the final raw digest value

if [[ -n "$BUILD_SOURCESDIRECTORY" ]]; then

  echo "##vso[task.setvariable variable=pushedDigest;]${DIGEST_VALUE}"

elif [[ -n "$GITHUB_ENV" ]]; then

  echo "PUSHED_DIGEST=$DIGEST_VALUE" >> $GITHUB_ENV
else
  echo $DIGEST_VALUE
fi