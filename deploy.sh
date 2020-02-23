#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"

eb config put $ENVIRONMENT

eb deploy $ENVIRONMENT

aws elasticbeanstalk update-environment \
    --environment-name $ENVIRONMENT \ 
    --application-name $APPLICATION \
    --region $AWS_REGION \
    --template-name $ENVIRONMENT
