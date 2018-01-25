#!/bin/bash -ex

git config --global user.name "Pipeline"
git config --global user.email flintstone@cloudfoundry.org

if [[ -z "${REPO_DIR}" ]] || [[ -z "${FILENAME}" ]] || [[ -z "${COMMIT_MESSAGE}" ]]; then
  echo "One of the required parameters is missing!"
  exit 1
fi

pushd "${REPO_DIR}"
  git add $FILENAME
  set +e
    git --no-pager diff --cached --exit-code
    HAS_CHANGES=$?
  set -e
  if [[ $HAS_CHANGES -eq 1 ]]; then
    git commit -m "${COMMIT_MESSAGE}"
  else
    echo "Nothing to commit"
  fi
popd
