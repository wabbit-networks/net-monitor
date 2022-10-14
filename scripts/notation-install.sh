#!/bin/bash

NOTATION_PATH=/usr/local/bin/notation
NOTATION_VERSION=0.9.0-alpha.1

# look for version string
notation --version | grep $NOTATION_VERSION

# if the previous command failed due to either
# - notation command not found, or
# - grep did not find the correct version string
# then the exit status will be non-zero
if [[ $? != 0 ]]; then
    # download
    curl -Lo notation.tar.gz https://github.com/notaryproject/notation/releases/download/v${NOTATION_VERSION}/notation_${NOTATION_VERSION}_linux_amd64.tar.gz

    # extract target release
    mkdir -p notation-install/
    tar xvzf notation.tar.gz -C notation-install/ notation

    # move to bin directory
    mv notation-install/notation $NOTATION_PATH

    # clean up
    rm -rf notation.tar.gz notation-install/
fi

notation --version