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