#!/bin/bash
# run this script inside your target repository
# like:
# cd myproject/
# ../git-hooks/install.sh

# Github references
repo=pagopa/git-hooks
branch=master

# to use local files instead of github's
is_local=$1


# check if is a git repo
if [ ! -d ".git" ]; then
  echo "Please run this script inside your target git repository"
  exit 1
fi

# check if git-secrets is installed
if [ ! -x $(command -v git-secrets > /dev/null 2>&1) ]; then
    echo "The git-secrets binary is not available. Install from source or package or check your PATH."
    echo "Visit https://github.com/awslabs/git-secrets for instructions."
    exit 1
fi

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

# copy a file from current file system or from github, depending from the value of $is_local
function copyFile {
    source=$1
    dest=$2
    if [ -z "$is_local" ]; then
        url="https://raw.githubusercontent.com/$repo/$branch/$source"
        echo "Download from $url"
        curl "$url" -o "$dest"
    else 
        # get script directory
        script_directory="$(dirname $0)"
        file="$script_directory/$source"
        echo "Copying $file"
        cp "$file" "$dest"
    fi
}


# install each hook
mkdir -p ".git/hooks"
for hook in "${hooks[@]}"
do
    source="hooks/$hook"
    dest=".git/hooks/$hook"
    copyFile "$source" "$dest"
    # make the hook executable
    chmod +x "$dest"
done

# install each provider and setup the git-secrets engine
# the configuration is saved in .git/config secrets.providers section
mkdir -p ".git/git-secrets-providers"
for provider in "${providers[@]}"
do
    source="providers/$provider"
    dest=".git/git-secrets-providers/$provider"
    copyFile "$source" "$dest"
    # add patterns
    git secrets --add-provider -- grep '^[^#[:space:]]' "$dest"
    echo "Added the following patterns to block local commits:"
    grep '^[^#[:space:]]' "$dest" # maybe avoid if too verbose in future
done

printf "\nAll done!\n"