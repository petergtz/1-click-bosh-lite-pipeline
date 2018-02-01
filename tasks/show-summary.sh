#!/bin/bash -e

export HOSTS_ENTRY="$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/hosts)"
export DIRECTOR_URL="https://$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/hosts | cut -f 2 -d ' '):25555/"
export CF_ADMIN_PASSWORD="$(bosh2 interpolate "state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml" --path=/cf_admin_password)"
export CA_CERT="$(bosh2 interpolate state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml --path /director_ssl/ca)"
export CLIENT_SECRET="$(bosh2 interpolate state/environments/softlayer/director/$BOSH_LITE_NAME/vars.yml --path /admin_password)"

envsubst < 1-click/tasks/summary.txt
