# 1-click-bosh-lite-pipeline

Okay, so it's not exactly "1 click", but this repository makes it almost trivial to deploy a BOSH Lite VM in the IBM Cloud (aka Softlayer).

The process is split into two parts, where the 2nd part is not strictly needed, but helpful. It contains:
1. operations files to generate a bosh deployment manifest that deploys a BOSH Lite in the IBM Cloud (aka Softlayer)
2. a `template.yml` to generate a Concourse pipeline to easily manage the BOSH Lite, i.e. it provides jobs to easily delete, re-create, etc. that environment.


## Generating the BOSH Lite Deployment manifest

```bash
bosh interpolate ~/workspace/bosh-deployment/bosh.yml \
    -o ~/workspace/bosh-deployment/softlayer/cpi.yml \
    -v sl_vlan_public=<PROVIDE>
    -v sl_vlan_private=<PROVIDE>
    -v sl_datacenter=<PROVIDE>
    -v internal_ip=127.0.0.1 \
    -v sl_vm_domain=<PROVIDE> \
    -v sl_vm_name_prefix=<PROVIDE> \
    -v sl_username=<PROVIDE> \
    -v sl_api_key=<PROVIDE> \
    -v director_name=bosh \
    -o ~/workspace/bosh-deployment/bosh-lite.yml \
    -o ~/workspace/bosh-deployment/bosh-lite-runc.yml \
    -o ~/workspace/1-click-bosh-lite-pipeline/operations/change-to-single-dynamic-network-named-default.yml \
    -o ~/workspace/1-click-bosh-lite-pipeline/operations/change-cloud-provider-mbus-host.yml \
    -o ~/workspace/1-click-bosh-lite-pipeline/operations/make-it-work-again-workaround.yml
```


## Creating the Concourse Pipeline to Manage the BOSH Lite VM

```bash
cat > config.yml <<EOF
meta:
  bosh-lite-name: my-bosh-lite
  state-git-repo: my-private-git-repo-that-will-contain-secrets
  cf-system-domain: my.bosh-lite.system.domain.com
EOF

# Hack: using sed to work around Concourse limitation. See bosh-create-env.sh for more details.
fly \
  -t my-target \
  set-pipeline \
  -p my-pipeline \
  -c <(spruce --concourse merge ~/workspace/1-click-bosh-lite-pipeline/template.yml config.yml) \
  -v github-private-key=<PROVIDE> \
  -v bosh-manifest="$(sed -e 's/((/_(_(/g' bosh-generated.yml )"
```