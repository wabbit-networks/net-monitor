#!/bin/bash
# Exit on Errors
set -e

# truncate a version to the first 6 characters.
VERSION=${SHA::6}

# set default PROJECT directory unless supplied
# : ${PROJECT_DIR:=./src/$PROJECT_NAME}

# set a default PUBLISH directory unless supplied.
# : ${PUBLISH_DIR:=$PROJECT_DIR}

msft-sbom generate \
-b . \
-bc . \
-di $IMAGE \
-m $SBOM_DIR \
-nsb http://wabbitnetworks.io \
-nsu $PROJECT_NAME \
-pn $PIPELINE.$PROJECT_NAME \
-pv $VERSION
-ps 'Wabbit Networks'

cp $SBOM_DIR/_manifest/spdx_2.2/manifest.spdx.json $SBOM_DIR/$PROJECT_NAME.spdx.json
