#!/bin/bash -ex

spruce --concourse merge template.yml $1 > result.yml

