#!/bin/bash

MSFT_SBOM_PATH=/usr/local/bin/msft-sbom
MSFT_SBOM_VERSION=0.1.2

# check if msft-sbom exists
which msft-sbom

# if the previous command failed,
# exit status will be non-zero
if [[ $? != 0 ]]; then
    # download
    curl -Lo msft-sbom https://github.com/microsoft/sbom-tool/releases/download/v${MSFT_SBOM_VERSION}/sbom-tool-linux-x64

    # make executable
    chmod +x msft-sbom

    # move to bin directory
    mv msft-sbom $MSFT_SBOM_PATH
fi