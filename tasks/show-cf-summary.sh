#!/bin/bash -e

echo '# Log on to CF'
echo "cf api --skip-ssl-validation api.$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/system_domain)"
echo "cf login -u admin -p $(bosh2 interpolate "state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml" --path=/cf_admin_password)"