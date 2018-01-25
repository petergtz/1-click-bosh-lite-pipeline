#!/bin/bash -ex

bosh2 interpolate cf-deployment/cf-deployment.yml \
    --vars-store state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml \
    -o cf-deployment/operations/bosh-lite.yml \
    -v system_domain=$CF_SYSTEM_DOMAIN \
    -o cf-deployment/operations/use-compiled-releases.yml \
    > out/manifest.yml

echo "Content of manifest.yml:"
cat out/manifest.yml

REPO_DIR=state \
    OP=add \
    FILENAME=environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml \
    COMMIT_MESSAGE="Update state for environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment" \
    ./1-click/tasks/commit-if-changed.sh

cp -a state/. out-state

