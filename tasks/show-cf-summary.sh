#!/bin/bash -e

export CF_ADMIN_PASSWORD="$(bosh2 interpolate "state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml" --path=/cf_admin_password)"

echo '# Log on to CF'
echo "cf api --skip-ssl-validation api.$CF_SYSTEM_DOMAIN"
echo "cf login -u admin -p $CF_ADMIN_PASSWORD"