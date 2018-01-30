#!/bin/bash -ex

mkdir -p state/environments/softlayer/director/$BOSH_LITE_NAME

# Hack to work around Concourse, which tries to interpret ((variables)).
# Simply "unescaping" `_(_(` to `((`: 
echo "$MANIFEST" | sed -e 's/_(_(/((/g' > bosh.yml

bosh2 create-env \
    --state state/environments/softlayer/director/$BOSH_LITE_NAME/state.json \
    --vars-store=state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml \
    bosh.yml \
    -v director_vm_prefix=$BOSH_LITE_NAME

tail -n1 /etc/hosts > state/environments/softlayer/director/$BOSH_LITE_NAME/hosts

REPO_DIR=state \
    OP=add \
    FILENAME="environments/softlayer/director/$BOSH_LITE_NAME/state.json environments/softlayer/director/$BOSH_LITE_NAME/vars.yml environments/softlayer/director/$BOSH_LITE_NAME/hosts" \
    COMMIT_MESSAGE="Update state for environments/softlayer/director/$BOSH_LITE_NAME" \
    1-click/tasks/commit-if-changed.sh

cp -a state/. out-state
