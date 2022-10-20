#!/bin/bash

ORAS_PATH=/usr/local/bin/oras
ORAS_VERSION=0.15.1

# look for version string
oras version | grep $ORAS_VERSION

# if the previous command failed due to either
# - oras command not found, or
# - grep did not find the correct version string
# then the exit status will be non-zero
if [[ $? != 0 ]]; then
    # download
    curl -Lo oras.tar.gz https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz

    # extract target release
    mkdir -p oras-install/
    tar -zxf oras.tar.gz -C oras-install/

    # move to bin directory
    mv oras-install/oras $ORAS_PATH

    # clean up
    rm -rf oras.tar.gz oras-install/
fi

oras version