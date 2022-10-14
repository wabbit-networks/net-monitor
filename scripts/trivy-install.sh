#!/bin/bash

TRIVY_PATH=/usr/local/bin/trivy
TRIVY_VERSION=0.32.1

# look for version string
trivy --version | grep $TRIVY_VERSION

# if the previous command failed due to either
# - trivy command not found, or
# - grep did not find the correct version string
# then the exit status will be non-zero
if [[ $? != 0 ]]; then
    # download
    curl -Lo trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

    # extract target release
    mkdir -p trivy-install/
    tar xvzf trivy.tar.gz -C trivy-install/ trivy

    # move to bin directory
    mv trivy-install/trivy $TRIVY_PATH

    # clean up
    rm -rf trivy.tar.gz trivy-install/
fi

trivy --version