#!/bin/bash -ex

if [ ! -e state/environments/softlayer/director/$BOSH_LITE_NAME/state.json ]; then
  echo 'Nothing to delete'
  cp -a state/. out-state
  exit 0
fi

echo "$MANIFEST" | sed -e 's/_(_(/((/g' > /tmp/bosh.yml

commit_if_changed=$(readlink -f 1-click/tasks/commit-if-changed.sh)

pushd state/environments/softlayer/director/$BOSH_LITE_NAME
    cat hosts >> /etc/hosts

    bosh2 delete-env \
        --state state.json \
        --vars-store=vars.yml \
        /tmp/bosh.yml \
        -v director_vm_prefix=$BOSH_LITE_NAME

    git rm state.json vars.yml hosts
    $commit_if_changed "Update state for environments/softlayer/director/$BOSH_LITE_NAME"
popd

cp -a state/. out-state
