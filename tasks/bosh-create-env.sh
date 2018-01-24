#!/bin/bash -ex

sudo bosh2 create-env \
    --state state/environments/softlayer/director/$BOSH_LITE_NAME/state.json \
    --vars-store=state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml \
    $MANIFEST

tail -n1 /etc/hosts > state/environments/softlayer/director/$BOSH_LITE_NAME/hosts

REPO_DIR=state \
    FILENAME="state/environments/softlayer/director/$BOSH_LITE_NAME/state.json state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml state/environments/softlayer/director/$BOSH_LITE_NAME/hosts" \
    COMMIT_MESSAGE="Update state for environments/softlayer/director/$BOSH_LITE_NAME" \
    1-click/tasks/commit-if-changed.sh

cp -a state/. out-state
