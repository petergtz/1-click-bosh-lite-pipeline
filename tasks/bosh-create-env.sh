#!/bin/bash -ex

# Hack to work around Concourse, which tries to interpret ((variables)).
# Simply "unescaping" `_(_(` to `((`: 
echo "$MANIFEST" | sed -e 's/_(_(/((/g' > /tmp/bosh.yml

commit_if_changed=$(readlink -f 1-click/tasks/commit-if-changed.sh)

mkdir -p state/environments/softlayer/director/$BOSH_LITE_NAME
pushd state/environments/softlayer/director/$BOSH_LITE_NAME
    bosh2 create-env \
        --state state.json \
        --vars-store=vars.yml \
        /tmp/bosh.yml \
        -v director_vm_prefix=$BOSH_LITE_NAME

    tail -n1 /etc/hosts > hosts

    git add state.json vars.yml hosts
    $commit_if_changed "Update state for environments/softlayer/director/$BOSH_LITE_NAME"
popd

cp -a state/. out-state
