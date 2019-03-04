#!/bin/bash -ex

# Hack to work around Concourse, which tries to interpret ((variables)).
# Simply "unescaping" `_(_(` to `((`:
echo "$MANIFEST" | sed -e 's/_(_(/((/g' > /tmp/bosh.yml

commit_if_changed=$(readlink -f 1-click/tasks/commit-if-changed.sh)

envrc_template_filename=$(readlink -nf 1-click/tasks/envrc-template)
set_env_template_filename=$(readlink -nf 1-click/tasks/set-env-template)

mkdir -p state/environments/softlayer/director/$BOSH_LITE_NAME
pushd state/environments/softlayer/director/$BOSH_LITE_NAME
    bosh2 create-env \
        --state state.json \
        --vars-store=vars.yml \
        /tmp/bosh.yml \
        -v director_vm_prefix=$BOSH_LITE_NAME

    hosts_entry=$(grep $BOSH_LITE_NAME /etc/hosts || true)
    if [ -n "$hosts_entry" ]; then
      echo $hosts_entry > hosts
      cut -d ' ' -f1 < hosts > ip
    fi

    bosh2 interpolate vars.yml --path /jumpbox_ssh/private_key > jumpbox.key

    export DIRECTOR_URL="https://$(cat hosts | cut -f 2 -d ' '):25555/"
    export CA_CERT="$(bosh2 interpolate vars.yml --path /director_ssl/ca)"
    export CLIENT_SECRET="$(bosh2 interpolate vars.yml --path /admin_password)"
    envsubst '${BOSH_LITE_NAME} ${DIRECTOR_URL} ${CA_CERT} ${CLIENT_SECRET} ${DOMAIN_NAME}' < $envrc_template_filename > .envrc
    envsubst '${BOSH_LITE_NAME} ${DIRECTOR_URL} ${CA_CERT} ${CLIENT_SECRET} ${DOMAIN_NAME}' < $set_env_template_filename > set-env.sh

    chmod u+x set-env.sh
    git add state.json vars.yml hosts jumpbox.key ip .envrc set-env.sh
    $commit_if_changed "Update state for environments/softlayer/director/$BOSH_LITE_NAME"
popd

cp -a state/. out-state
