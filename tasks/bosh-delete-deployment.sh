#!/bin/bash -ex

. 1-click/tasks/bosh-login.sh

bosh2 -n -d $DEPLOYMENT_NAME delete-deployment

commit_if_changed=$(readlink -f 1-click/tasks/commit-if-changed.sh)

if [ -e state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml ]; then
    pushd state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment
        git rm -f vars.yml
    popd
    pushd state
        $commit_if_changed "Update state for environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment"
    popd
fi

cp -a state/. out-state
