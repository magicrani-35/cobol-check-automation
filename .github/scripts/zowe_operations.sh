#! /bin/bash

# zowe_operations.sh

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Check if directory exists, create if it doesn't 
if ! zowe  zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"; then
  set -euxo pipefail
  echo "Directory does not exists. Creating it..."
  zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
  echo "Directory already exists."
fi

# Upload Files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive
      --binary-files "cobol-check-0.2.19.jar"

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobol-check"
