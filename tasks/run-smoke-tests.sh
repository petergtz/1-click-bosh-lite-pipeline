#!/bin/bash -ex

mkdir -p gopath/src/github.com/cloudfoundry
cp -a cf-smoke-tests gopath/src/github.com/cloudfoundry/
export GOPATH=$PWD/gopath
export PATH=$PATH:$GOPATH/bin

cf version

cf_admin_password=$(bosh2 int state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/vars.yml --path /cf_admin_password)
CF_SYSTEM_DOMAIN=$(cat state/environments/softlayer/director/$BOSH_LITE_NAME/cf-deployment/system_domain)

cat > config.json <<EOF
{
  "suite_name"                      : "CF_SMOKE_TESTS",
  "api"                             : "api.${CF_SYSTEM_DOMAIN}",
  "apps_domain"                     : "${CF_SYSTEM_DOMAIN}",
  "user"                            : "admin",
  "password"                        : "${cf_admin_password}",
  "cleanup"                         : false,
  "use_existing_org"                : true,
  "org"                             : "system",
  "use_existing_space"              : false,
  "logging_app"                     : "",
  "runtime_app"                     : "",
  "enable_windows_tests"            : false,
  "windows_stack"                   : "windows2012R2",
  "enable_etcd_cluster_check_tests" : false,
  "etcd_ip_address"                 : "",
  "backend"                         : "diego",
  "isolation_segment_name"          : "is1",
  "isolation_segment_domain"        : "is1.bosh-lite.com",
  "enable_isolation_segment_tests"  : false,
  "skip_ssl_validation"             : true
}
EOF
export CONFIG="$(readlink -nf config.json)"

cd gopath/src/github.com/cloudfoundry/cf-smoke-tests

# Using nodes=1, because multiple nodes seem to cause race-conditions. Is that a bug in cf-smoke-tests?
bin/test -v -r -slowSpecThreshold=120 -randomizeAllSpecs -nodes=1 -keepGoing
