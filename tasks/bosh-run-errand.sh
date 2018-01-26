#!/bin/bash -ex

. 1-click/tasks/bosh-login.sh

bosh2 run-errand -d cf smoke-tests
