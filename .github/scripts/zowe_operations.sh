#! /bin/bash

# zowe_operations.sh

set -euo pipefail

# Convert the mainframe username to lowercase for its USS home path. 
LOWERCASE_USERNAME=$(
  echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]'
  )

USS_HOME="/z/$LOWERCASE_USERNAME"
TARGET_DIRECTORY="$USS_HOME/cobolcheck"

# Verify that GitHub Actions can connect and access the USS home. 
echo "Checking USS home directory..."
zowe zos-files list uss-files "$USS_HOME"

# Create the COBOL Check directory when it does not exist.
if zowe zos-files list uss-files "$TARGET_DIRECTORY";
then
  echo "Directory already exists: $TARGET_DIRECTORY"
else
  echo "Creating directory: $TARGET_DIRECTORY"
  zowe zos-files create uss-directory "$TARGET_DIRECTORY"
fi

#Upload the local COBOL Check distribution.
echo "Uploading COBOL Check..."
zowe zos-files upload dir-to-uss \
  "./cobol-check" \
  "$TARGET_DIRECTORY" \
  --recursive \
  --binary-files "*.jar"

# Verify the uploaded contents.
echo "Verifying upload..."
zowe zos-files list uss-files "$TARGET_DIRECTORY" 



