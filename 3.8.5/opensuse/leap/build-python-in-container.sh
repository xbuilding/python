#!/usr/bin/env bash

bash /scripts/config-source.sh

mkdir "${DIST_DIR}"
chmod 777 "${DIST_DIR}"
bash -x build.sh
tar -zcf "$OUTPUT_DIR/$OUTPUT_NAME" "${DIST_DIR}"
