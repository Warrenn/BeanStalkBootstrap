#!/bin/bash

set -e

# export PATH="/root/.ebcli-virtual-env/executables:$PATH"

yq -Y -s ".[0] * .[1]" common.env.yaml "$ENVIRONMENT".env.yaml > env.yaml

eb deploy $ENVIRONMENT