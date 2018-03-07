#!/bin/bash -e

mkdir -p state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/

CF_SYSTEM_DOMAIN="$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/ip).nip.io"

bosh2 interpolate cf-deployment/cf-deployment.yml \
    --vars-store state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml \
    -o cf-deployment/operations/bosh-lite.yml \
    -v system_domain=$CF_SYSTEM_DOMAIN \
    -o cf-deployment/operations/use-compiled-releases.yml \
    -o cf-deployment/operations/experimental/use-bosh-dns.yml \
    -o 1-click/operations/add-dns-alias-internal-public-access-entry.yml \
    > state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/manifest.yml

commit_if_changed=$(readlink -f 1-click/tasks/commit-if-changed.sh)
pushd state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/
    echo $CF_SYSTEM_DOMAIN > system_domain
    git add vars.yml manifest.yml system_domain
    $commit_if_changed "Update state for environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment"
popd

cp -a state/. out-state

