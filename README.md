# GIT HOOKS

A collection of opinionated git hooks to automate part of our workflow

## Sentences you will never hear again

- Someone leaked a database key, we need to regenerate it. @here update all your local secret files.
- Oops! I forgot to fix tests, too.
- LGTM but fix lint errors before merging.
- After merging your branch it doesn't compile anymore! | _Have you tried `yarn install`?_ | oops...

## Features

- Prevent from committing secrets
- Update dependencies when switching/merging branches
- Prevent from pushing untested code
- Prepend the commit message with the storyid

## Requirements

- `git-secrets` - see [here](https://github.com/awslabs/git-secrets) for more info.

## Installation

### From a remote script

`cd` into your target project's root and then

```bash
bash <(curl -s https://raw.githubusercontent.com/pagopa/git-hooks/master/install.sh)
```

### Locally

Clone this repository anywhere in your machine, `cd` into your target project's root and then

```bash
path/to/git-hooks-repo/install.sh 1
```

Alternatively, pick any hook you like in `./hooks` folder and copy&paste into the `.git/hooks` folder of your project.

## Hooks

See `./hooks` folder for details
