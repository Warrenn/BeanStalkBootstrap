#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"


if [eb list --all | grep $ENVIRONMENT]; then
    eb create $ENVIRONMENT
fi

eb deploy $ENVIRONMENT