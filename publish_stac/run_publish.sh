#!/bin/bash
# DPS publish courier: copy a prepared, self-contained STAC catalog into this
# job's output directory. catalog.json arriving in dps_output triggers
# ingestion into the internal DPS STAC (dps-stac.maap-project.org).
#   $1  s3:// folder containing catalog.json and the collection/item tree
set -eo pipefail
mkdir -p output
if command -v aws >/dev/null 2>&1; then
    aws s3 cp --recursive "$1" output/
else
    python3 - "$1" <<'PY'
import boto3, os, sys
from urllib.parse import urlparse
u = urlparse(sys.argv[1])
bucket, prefix = u.netloc, u.path.lstrip("/")
if prefix and not prefix.endswith("/"):
    prefix += "/"
s3 = boto3.client("s3")
n = 0
for pg in s3.get_paginator("list_objects_v2").paginate(Bucket=bucket, Prefix=prefix):
    for o in pg.get("Contents", []):
        rel = o["Key"][len(prefix):]
        if not rel or rel.endswith("/"):
            continue
        dst = os.path.join("output", rel)
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        s3.download_file(bucket, o["Key"], dst)
        n += 1
print("copied", n, "objects with boto3")
PY
fi
find output -type f | head -20
