#!/bin/bash -ex

# Hack to work around Concourse, which tries to interpret ((variables)).
# Simply "unescaping" `_(_(` to `((`:
echo "$MANIFEST" | sed -e 's/_(_(/((/g' > /tmp/bosh.yml

commit_if_changed=$(readlink -f 1-click/tasks/commit-if-changed.sh)

envrc_template_filename=$(readlink -nf 1-click/tasks/envrc-template)

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

    envsubst < $envrc_template_filename > .envrc

    git add state.json vars.yml hosts jumpbox.key ip .envrc
    $commit_if_changed "Update state for environments/softlayer/director/$BOSH_LITE_NAME"
popd

cp -a state/. out-state
