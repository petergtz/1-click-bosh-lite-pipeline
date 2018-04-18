#!/bin/bash -ex

pushd state/environments/softlayer/director/$BOSH_LITE_NAME
    cat hosts >> /etc/hosts

    export BOSH_CLIENT=admin
    export BOSH_CLIENT_SECRET=`bosh2 int ./vars.yml --path /admin_password`
    export BOSH_CA_CERT=$(bosh2 int ./vars.yml --path /director_ssl/ca)
    export BOSH_ENVIRONMENT=$(cat hosts | cut -f 2 -d ' ')
    export BOSH_NON_INTERACTIVE=true
popd
