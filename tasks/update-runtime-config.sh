#!/bin/bash -ex

export PATH=$PATH:$(readlink -f 1-click/tasks)

. 1-click/tasks/bosh-login.sh

bosh2 -n update-runtime-config \
    --vars-store=state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml \
    bosh-deployment/runtime-configs/dns.yml

pushd state/environments/softlayer/director/$BOSH_LITE_NAME
    git add vars.yml
    commit-if-changed.sh "Update state for environments/softlayer/director/$BOSH_LITE_NAME"
popd

cp -a state/. out-state
