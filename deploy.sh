#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"

eb deploy $ENVIRONMENT