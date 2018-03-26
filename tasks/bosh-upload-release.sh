#!/bin/bash -e

. 1-click/tasks/bosh-login.sh

bosh2 upload-release releases/$RELEASE_TARBALL
