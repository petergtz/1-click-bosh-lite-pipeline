#!/bin/bash -ex

. 1-click/tasks/bosh-login.sh

TASK_ID=$(bosh2 -d $DEPLOYMENT_NAME tasks | cut -f 1)

if [ $TASK_ID ]; then
    bosh2 cancel-task $(bosh2 -d $DEPLOYMENT_NAME tasks | cut -f 1)
else
    echo "No tasks running."
fi