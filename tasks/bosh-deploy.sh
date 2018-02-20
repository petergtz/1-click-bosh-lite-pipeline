#!/bin/bash -e

. 1-click/tasks/bosh-login.sh

bosh2 upload-stemcell $(cat stemcell/source)
bosh2 -n -d cf deploy state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/manifest.yml
