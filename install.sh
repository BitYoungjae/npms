#!/bin/bash

NPMS_SCRIPT_URL=https://raw.githubusercontent.com/bityoungjae/npms/main/npms.sh

# Fetch the content to be installed from the remote script
NPMS_CONTENT=$(curl -fs $NPMS_SCRIPT_URL)

# Check if fzf and jq are installed
if ! command -v fzf &> /dev/null || ! command -v jq &> /dev/null; then
  echo "Cannot find jq and fzf. Please install these required packages first."
  exit 1
fi

# Check if the curl command succeeded
if [ $? -ne 0 ]; then
  echo "Failed to fetch the npms script."
  exit 1
fi

# Check current shell and select appropriate profile file
if [[ "$SHELL" == */bash ]]; then
  PROFILE_FILE="$HOME/.bashrc"
elif [[ "$SHELL" == */zsh ]]; then
  PROFILE_FILE="$HOME/.zshrc"
else
  echo "Unsupported shell. Please manually install using the script linked below."
  echo $NPMS_SCRIPT_URL
  exit 1
fi

# Checking if the npms script is already added
if grep -q "# npms-script-start" "$PROFILE_FILE"; then
  echo "npms alias is already added to $PROFILE_FILE."
  exit 1
fi

echo "Adding npms alias to $PROFILE_FILE.."

# If the file does not end with a newline, add one.
if [[ "$(tail -c 1 "$PROFILE_FILE")" != "" ]]; then
  echo >> "$PROFILE_FILE"
fi

echo >> "$PROFILE_FILE"
echo "$NPMS_CONTENT" >> "$PROFILE_FILE"
echo "Added successfully."
echo "Please run 'source $PROFILE_FILE' and then type 'npms' in the terminal."
