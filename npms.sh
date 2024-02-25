# npms-script-start::1.0.0
run_npm_script() {
  # Finds the path to the nearest package.json in the current directory
  local package_json_path=$(npm prefix --silent)/package.json

  if [[ ! -f "$package_json_path" ]]; then
    echo "Cannot find package.json file."
    return
  fi

  # Excludes life cycle operations from the list.
  local life_cycle_ops_json='["preinstall", "install", "postinstall", "preuninstall", "uninstall", "postuninstall", "preversion", "version", "postversion", "pretest", "posttest", "prepublish", "prepare", "prepublishOnly", "postpublish", "prepack", "postpack", "prestop", "stop", "poststop", "prestart", "start", "poststart", "prerestart", "restart", "postrestart"]'
  local name=$(jq -r --argjson life_cycle_ops "$life_cycle_ops_json" '.scripts | keys | map(select(. as $x | $life_cycle_ops | index($x) | not))[]' "$package_json_path" | fzf)
  
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
# npms-script-end
