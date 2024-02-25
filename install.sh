#!/bin/bash

# Content to be installed
NPMS_CONTENT='
# npms-script-start
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

# Setting paths for .bashrc or .zshrc files
PROFILE_FILES=("$HOME/.bashrc" "$HOME/.zshrc")

# Check if fzf and jq are installed
if ! command -v fzf &> /dev/null || ! command -v jq &> /dev/null; then
  echo "Cannot find jq and fzf. Please install these required packages first."
else
  for file in "${PROFILE_FILES[@]}"; do
    if [ -f "$file" ]; then
      # Checking if the npms script is already added
      if ! grep -q "# npms-script-start" "$file"; then
        echo "Adding npms alias to $file.."
        # If the file does not end with a newline, add one at the beginning.
        if [[ ! "$(tail -c 1 "$file" | tr -d '[:space:]')" == "" ]]; then
          echo "" >> "$file"
        fi
        echo "$NPMS_CONTENT" >> "$file"
        echo "Added successfully."
        echo "Please run 'source $file' and then type 'npms' in the terminal."
      else
        echo "npms alias is already added to $file."
      fi
    fi
  done
fi
