#!/bin/bash
# run this script inside your target repository
# like:
# cd myproject/
# ../git-hooks/install.sh

# check if is a git repo
if [ ! -d ".git" ]; then
  echo "Please run this script inside your target git repository"
  exit 1
fi

# check if git-secrets is installed
if [ ! -x $(command -v git-secrets > /dev/null 2>&1) ]; then
    echo "The git-secrets binary is not available. Install from source or package or check your PATH."
    exit 1
fi

# TODO we could avoid the array declaration and traverse the dirs
# hooks to be installed
declare -a hooks=(
    "post-checkout"
    "post-merge"
    "pre-push"
    "pre-commit"
)

# providers to be installed
declare -a providers=(
    "commons"
)

# get script directory
script_directory="$(dirname $0)"

# install each hook
mkdir -p ".git/hooks"
for hook in "${hooks[@]}"
do
    dest=".git/hooks/$hook"
    file="$script_directory/hooks/$hook"
    echo "Copying hook file: $file"
    cp "$file" "$dest"
    chmod +x "$dest"
done

# install each provider and setup the git-secrets engine
# the configuration is saved in .git/config secrets.providers section
mkdir -p ".git/git-secrets-providers"
for provider in "${providers[@]}"
do
    dest=".git/git-secrets-providers/$provider"
    file="$script_directory/providers/$provider"
    echo "Copying provider file: $file"
    cp "$file" "$dest"
    # add patterns
    git secrets --add-provider -- grep '^[^#[:space:]]' $dest
    echo "Added the following patterns to block local commits:"
    grep '^[^#[:space:]]' $dest # maybe avoid if too verbose in future
done

printf "\nAll done!\n"