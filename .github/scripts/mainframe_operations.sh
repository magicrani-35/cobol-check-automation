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
  "pwd; java -version; ls -la; ls -la bin; ls -la scripts" \
  --cwd "$COBOL_CHECK_DIRECTORY" \
  --host "$ZOWE_OPT_HOST" \
  --port 22 \
  --user "$ZOWE_USERNAME" \
  --password "$ZOWE_PASSWORD" \
  --host-key "SHA256:1YtEA18or6MI0VQnVQn7ZUCtFVkJMRStN+DnqJZaxPk"

echo "Remote USS verification completed."

















































