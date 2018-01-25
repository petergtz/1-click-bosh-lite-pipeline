#!/bin/bash -ex

pushd state/environments/softlayer/director/$BOSH_LITE_NAME
    cat hosts >> /etc/hosts

    bosh2 alias-env my-env -e $(cat hosts | cut -f 2 -d ' ') --ca-cert <(bosh2 int ./vars.yml --path /director_ssl/ca)
    export BOSH_CLIENT=admin
    export BOSH_CLIENT_SECRET=`bosh2 int ./vars.yml --path /admin_password`
    export BOSH_ENVIRONMENT=my-env
popd
