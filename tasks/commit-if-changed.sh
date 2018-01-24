#!/bin/bash -ex

if [[ -z "${REPO_DIR}" ]] || [[ -z "${FILENAME}" ]] || [[ -z "${COMMIT_MESSAGE}" ]]; then
  echo "One of the required parameters is missing!"
  exit 1
fi

pushd "${REPO_DIR}"
  set +e
    git diff --exit-code -- $FILENAME
    exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    echo "There are no changes to commit."
  else
    git config --global user.name "Pipeline"
    git config --global user.email flintstone@cloudfoundry.org

    git add $FILENAME
    git --no-pager diff --cached
    git commit -m "${COMMIT_MESSAGE}"
  fi
popd
