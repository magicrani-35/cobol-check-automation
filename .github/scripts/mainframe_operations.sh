#! /bin/bash

# mainframe_operations.sh

set -euo pipefail

# Convert the mainframe username to lowercase for the USS home path.
LOWERCASE_USERNAME=$(
  echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]'
)

USS_HOME="/z/$LOWERCASE_USERNAME"
COBOL_CHECK_DIRECTORY="$USS_HOME/cobolcheck"

echo "Connecting to USS with Zowe SSH..."
echo "Remote COBOL Check directory:
$COBOL_CHECK_DIRECTORY"

zowe zos-ssh issue command \
  "java -jar bin/cobol-check-0.2.19.jar --programs NUMBERS && test -s 'testruns/CC##99.CBL' && cp 'testruns/CC##99.CBL' \"//'${ZOWE_USERNAME}.CBL(NUMBERS)'\"" \
  --cwd "$COBOL_CHECK_DIRECTORY" \
  --host "$ZOWE_HOST" \
  --port 22 \
  --user "$ZOWE_USERNAME" \
  --password "$ZOWE_PASSWORD" \
  --host-key "$ZOWE_HOST_KEY"

# 2. Upload the repository's NUMBERS.JCL into Z83410.JCL(NUMBERS).
echo "Uploading NUMBERS.JCL to ${ZOWE_USERNAME}.JCL(NUMBERS)..."

zowe zos-files upload file-to-data-set \
  "./NUMBERS>JCL" \
  "${ZOWE_USERNAME}.JCL(NUMBERS)" \
  --host "$ZOWE_HOST" \
  --port 10443 \
  --user "$ZOWE_USERNAME" \
  --password "$ZOWE_PASSWORD" \
  --reject-unauthorized false

echo "NUMBERS COBOL and JCL members deployed successfully."

echo "Remote USS verification completed."

















































