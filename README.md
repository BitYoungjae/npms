# NPMS

A convenient script runner for npm, yarn, and pnpm package managers.

## About

**NPMS** is a convenient script runner that lets you browse, search, and execute scripts defined in `package.json` right from the terminal.

## Prerequisites

Before installing NPMS, make sure `fzf` and `jq` are installed on your system.
If not, use the commands below to install them.

```sh
# Install fzf
brew install fzf

# Install jq
brew install jq
```

## Install Script

To install or update nvm, you should run the install script.

```sh
# Using curl
curl -o- https://raw.githubusercontent.com/bityoungjae/npms/main/install.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/bityoungjae/npms/main/install.sh | bash
```

## Usage

After installation, just type `npms` in your terminal.
It will show you a list of scripts you can run, all based on the nearest `package.json`.
Then, with `fzf`, you can search and choose the script you want to run.
