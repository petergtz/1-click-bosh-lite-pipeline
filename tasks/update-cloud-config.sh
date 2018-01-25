#!/bin/bash -ex

. 1-click/tasks/bosh-login.sh

bosh2 -n update-cloud-config cf-deployment/iaas-support/bosh-lite/cloud-config.yml
