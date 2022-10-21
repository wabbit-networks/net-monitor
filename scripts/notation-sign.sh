#!/bin/bash

# Usage:
#   export ACR_NAME=<string>            required    the name of the ACR registry resource
#   export ARTIFACT=<string>            required    the repo of the artifact to sign ({registry}/{repo})
#   export MANIFEST_TYPE=<string>       required....the type of manifest notation will pull down and sign
#       image "media" manifest type: application/vnd.docker.distribution.manifest.v2+json
#       non-image (SBOM, signature, blob, etc) "media" manifest type: application/vnd.cncf.oras.artifact.manifest.v1+json

if [[ -z "$ARTIFACT" ]]; then
    echo "No valid artifact to sign"
    exit 1
fi

if [[ -z "$MANIFEST_TYPE" ]]; then
    echo "No valid manifest type for artifact"
    exit 1
fi

# TOKEN=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)

# export USER_NAME="00000000-0000-0000-0000-000000000000"
# export NOTATION_PASSWORD=$TOKEN

notation plugin ls
notation key ls
notation key add --name wabbit-networks-io --plugin azure-kv --id $NOTATION_KEY_ID
notation key ls
notation sign --media-type $MANIFEST_TYPE $ARTIFACT