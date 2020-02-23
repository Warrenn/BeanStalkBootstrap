#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"

yq -Y -s ".[0] * .[1]" "$ENVIRONMENT".env.yaml common.env.yaml > env.yaml

eb deploy $ENVIRONMENT