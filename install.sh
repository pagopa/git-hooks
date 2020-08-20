#!/bin/bash

repo=pagopa/git-hooks
branch=master

# to use local files instead of github's
is_local=$1

# check if is a git repo
if [ ! -d ".git" ]; then
  echo "Please run this script inside a git repository"
  exit 1
fi

# hooks to be installed
declare -a hooks=(
    "post-checkout"
    "post-merge"
    "pre-push"
    "pre-commit"
)

# install each hook
for hook in "${hooks[@]}"
do
    dest=".git/hooks/$hook"
    if [ -z "$is_local" ]; then
        url="https://raw.githubusercontent.com/$repo/$branch/hooks/$hook"
        echo "Download from $url"
        curl "$url" -o "$dest"
    else 
        script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
        file="$script_directory/hooks/$hook"
        echo "Copying $file"
        cp "$file" "$dest"
    fi

    chmod +x "$dest"
done

# Install git-secrets command
function command_exists {
  #this should be a very portable way of checking if something is on the path
  #usage: "if command_exists foo; then echo it exists; fi"
  type "$1" &> /dev/null
}

if [ ! -f /usr/local/bin/git-secrets ]; then 
    echo "You don't have git secrets installed. It will be used by some hooks."
    read -p "Would you like to install git secrets (y/n)? " -n 1 -r
    echo   
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing git-secrets"
        download_dir="/tmp/git-secrets-$(date +%s)"
        git clone --depth 1 https://github.com/awslabs/git-secrets.git $download_dir
        cd $download_dir || exit
        make install
        echo "git-secrets installed. Please see https://github.com/awslabs/git-secrets for command usage."
    fi
fi