#!/bin/bash -ex

. 1-click/tasks/bosh-login

bosh2 -n clean-up --all
