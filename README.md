# GIT HOOKS

A collection of opinionated git hooks to automate part of our workflow

## Features
* Prevent from committing secrets
* Update dependencies when switching/merging branches
* Prevent from pushing untested code

## Requirements
* `git-secrets` - see [here](https://github.com/awslabs/git-secrets) for more info.

## Installation

### From a remote script
`cd` into your repository's root and then
```bash
bash <(curl -s https://raw.githubusercontent.com/pagopa/git-hooks/master/install.sh)
```

### Locally
Clone this repository anywhere in your machine, `cd` into your repository's root and then
```bash
path/to/git-hooks-repo/install.sh 1
```

Alternatively, pick any hook you like in `./hooks` folder and copy&paste into the `.git/hooks` folder of your project.

## Hooks
See `./hooks` folder for details
