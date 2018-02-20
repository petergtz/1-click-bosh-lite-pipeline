#!/bin/bash -e

IP=$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/ip)
CF_SYSTEM_DOMAIN="$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/ip).nip.io"

echo "Make sure the following DNS entry exists:"
echo "hostname *.$CF_SYSTEM_DOMAIN -> $IP"

set +e
nslookup api.$CF_SYSTEM_DOMAIN | grep "$IP"
EXIT_CODE=$?
set -e
until [[ $EXIT_CODE -eq 0 ]]; do
    echo "Waiting for you to make the change..."
    sleep 10
    set +e
    nslookup api.$CF_SYSTEM_DOMAIN | grep "$IP"
    EXIT_CODE=$?
    set -e
done
