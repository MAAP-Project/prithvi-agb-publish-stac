#!/bin/bash
# DPS publish courier: copy a prepared, self-contained STAC catalog into this
# job's output directory. DPS uploads output/ to the watched dps_output path,
# and the catalog.json arriving there triggers ingestion into the internal
# DPS STAC (dps-stac.maap-project.org).
#
# $1  s3:// folder containing catalog.json and the collection/item tree
set -eo pipefail
mkdir -p output
aws s3 cp --recursive "$1" output/
ls -laR output/ | head -40
