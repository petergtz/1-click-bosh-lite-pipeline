#!/bin/bash -ex

if [ ! -e state/environments/softlayer/director/$BOSH_LITE_NAME/state.json ]; then
  echo 'Nothing to delete'
  exit 0
fi

cat state/environments/softlayer/director/$BOSH_LITE_NAME/hosts >> /etc/hosts

bosh2 delete-env \
    --state state/environments/softlayer/director/$BOSH_LITE_NAME/state.json \
    --vars-store=state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml \
    $MANIFEST \
    -v director_vm_prefix=$BOSH_LITE_NAME

rm -f state/environments/softlayer/director/$BOSH_LITE_NAME/state.json
rm -f state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml
rm -f state/environments/softlayer/director/$BOSH_LITE_NAME/hosts

REPO_DIR=state \
    OP=rm \
    FILENAME="environments/softlayer/director/$BOSH_LITE_NAME/state.json environments/softlayer/director/$BOSH_LITE_NAME/vars.yml environments/softlayer/director/$BOSH_LITE_NAME/hosts" \
    COMMIT_MESSAGE="Update state for environments/softlayer/director/$BOSH_LITE_NAME" \
    1-click/tasks/commit-if-changed.sh

cp -a state/. out-state
