#!/usr/bin/env ruby

require 'yaml'

ops_file = YAML.load_file('cf-deployment/operations/use-compiled-releases.yml')

versions = ops_file
           .select { |op| op['path'] =~ %r(/releases/name=.+/stemcell) }
           .map { |op| op['value']['version'] }

unique_versions_count = versions.uniq.size

if unique_versions_count == 0
  warn "Could not find a stemcell version."
  exit 1
elsif unique_versions_count > 1
  warn "Found #{unique_versions_count} unique stemcell versions. Don't know which one to take."
  exit 2
end

stemcell_version = "https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v=#{versions.first}"
puts stemcell_version
File.write('stemcell/source', stemcell_version)
