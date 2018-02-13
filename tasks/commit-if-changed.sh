#!/bin/bash -e

git config --global user.name "Pipeline"
git config --global user.email flintstone@cloudfoundry.org

if [[ -z "$1" ]]; then
  echo "Please provide a commit message as argument"
  exit 1
fi

set +e
  git --no-pager diff --cached --exit-code --quiet
  HAS_CHANGES=$?
set -e
if [[ $HAS_CHANGES -eq 1 ]]; then
  git commit -m "$1"
else
  echo "Nothing to commit"
fi
