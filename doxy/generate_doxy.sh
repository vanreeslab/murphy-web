#!/bin/bash

MURPHY_DOC_DIR="/Users/wvanrees/software/murphy/doc/"
DOXYBOOK2_EXEC="../doxybook2-osx-amd64-v1.4.0/bin/doxybook2"

DOXYBOOK2_OUT_DIR="../docs/doxybook2/"

if [ -d ${DOXYBOOK2_OUT_DIR} ]; then
    echo "directory ${DOXYBOOK2_OUT_DIR} exists - removing"
    rm -r ${DOXYBOOK2_OUT_DIR}/*
fi

#echo "generate doxybook files"
${DOXYBOOK2_EXEC} --config config.json --input ${MURPHY_DOC_DIR}/xml --output ${DOXYBOOK2_OUT_DIR}


