#!/bin/bash

# Content to be installed
NPMS_CONTENT='
# npms-script-start::1.0.0
run_npm_script() {
  # Finds the path to the nearest package.json in the current directory
  local package_json_path=$(npm prefix --silent)/package.json

  if [[ ! -f "$package_json_path" ]]; then
    echo "Cannot find package.json file."
    return
  fi

  # Excludes life cycle operations from the list.
  local life_cycle_ops="(preinstall|install|postinstall|preuninstall|uninstall|postuninstall|preversion|version|postversion|pretest|posttest|prepublish|prepare|prepublishOnly|postpublish|prepack|postpack|prestop|stop|poststop|prestart|start|poststart|prerestart|restart|postrestart)"
  local name=$(jq -r ".scripts | keys | .[]" "$package_json_path" | grep -vE $life_cycle_ops | fzf)

  if [[ -n "$name" ]]; then
    echo "Running '$name'"

    local package_lock_path=$(npm prefix --silent)/package-lock.json
    local yarn_lock_path=$(npm prefix --silent)/yarn.lock
    local pnpm_lock_path=$(npm prefix --silent)/pnpm-lock.yaml

    if [[ -f "$package_lock_path" ]]; then
      npm run $name
    elif [[ -f "$yarn_lock_path" ]]; then
      yarn $name
    elif [[ -f "$pnpm_lock_path" ]]; then
      pnpm $name
    else
      echo "Cannot determine the package manager to execute the script."
    fi
  else
    echo "No script selected."
  fi
}
alias npms="run_npm_script"
# npms-script-end'

# Check current shell and select appropriate profile file
if [[ "$SHELL" == */bash ]]; then
  PROFILE_FILE="$HOME/.bashrc"
elif [[ "$SHELL" == */zsh ]]; then
  PROFILE_FILE="$HOME/.zshrc"
else
  echo "Unsupported shell. Please manually install using the script linked below."
  echo "https://github.com/BitYoungjae/npms/blob/main/npms.sh"
  exit 1
fi

# Check if fzf and jq are installed
if ! command -v fzf &> /dev/null || ! command -v jq &> /dev/null; then
  echo "Cannot find jq and fzf. Please install these required packages first."
  exit 1
else
  # Checking if the npms script is already added
  if ! grep -q "# npms-script-start" "$PROFILE_FILE"; then
    echo "Adding npms alias to $PROFILE_FILE.."
    # If the file does not end with a newline, add one at the beginning.
    if [[ ! "$(tail -c 1 "$PROFILE_FILE" | tr -d '[:space:]')" == "" ]]; then
        echo "" >> "$PROFILE_FILE"
    fi
    echo "$NPMS_CONTENT" >> "$PROFILE_FILE"
    echo "Added successfully."
    echo "Please run 'source $PROFILE_FILE' and then type 'npms' in the terminal."
  else
    echo "npms alias is already added to $PROFILE_FILE."
  fi
fi
