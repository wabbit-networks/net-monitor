#!/bin/bash

# Usage
# SECRET_ID             ID for the "secret" component of AKV certificate    preferred**
# VAULT_NAME            name of the AKV resource                            optional**
# CERT_NAME             name of the AKV certificate                         optional**
# NOTATION_DIRECTORY    file path for storing key/cert                      optional
# **Either SECRET_ID OR (VAULT_NAME + CERT_NAME) are REQUIRED; If SECRET_ID is provided, it will be used to pull the certificate down.

# Notation file path settings
if [[ -z "$NOTATION_DIRECTORY" ]]; then
    # If not set, use the default path for notation config files
    NOTATION_DIRECTORY="$HOME/.notation"
fi

if [[ ! -d $NOTATION_DIRECTORY ]]; then
    mkdir -p $NOTATION_DIRECTORY
fi

if [[ -n "$CERT_NAME" ]]; then
    SECRET_NAME=$CERT_NAME
else
    SECRET_NAME=$(az keyvault secret show --id $SECRET_ID --query name -o tsv)
fi

# File name settings
KEY_FILE="$NOTATION_DIRECTORY/$SECRET_NAME.key"
CERT_FILE="$NOTATION_DIRECTORY/$SECRET_NAME.crt"

# Pull secret value from key vault, base64 decode, and then read 
# as a pkcs12 file without encoding the private key (-nodes)
# the password flag can take many formats - search "pass phrase"
# in https://www.openssl.org/docs/man1.1.1/man1/openssl.html for info

if [[ -z "$SECRET_ID" ]]; then
    echo "No SECRET_ID, using cert name & vault to retrieve latest"
    az keyvault secret show --name $SECRET_NAME --vault-name $VAULT_NAME --query value -o tsv \
        | openssl enc -a -A -d -out $SECRET_NAME.p12
else
    echo "SECRET_ID provided, retrieving specific version"
    az keyvault secret show --id $SECRET_ID --query value -o tsv \
        | openssl enc -a -A -d -out $SECRET_NAME.p12
fi

openssl pkcs12 -in $SECRET_NAME.p12 -nodes -password pass: -nokeys -out $CERT_FILE
openssl pkcs12 -in $SECRET_NAME.p12 -nodes -password pass: -nocerts -out $KEY_FILE

rm $SECRET_NAME.p12 

notation key add --default --name $SECRET_NAME $KEY_FILE $CERT_FILE
