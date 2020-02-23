#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"

eb deploy $ENVIRONMENT

aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT --application-name $APPLICATION --region $AWS_REGION --option-settings file://$PWD/.optionsettings/$ENVIRONMENT.json
