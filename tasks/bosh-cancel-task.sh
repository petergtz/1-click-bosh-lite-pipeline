#!/bin/bash -ex

. 1-click/tasks/bosh-login.sh

bosh2 cancel-task $(bosh2 -d $DEPLOYMENT_NAME tasks | cut -f 1)