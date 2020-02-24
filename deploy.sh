#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"

# Docker is not getting the environemnt variables correctly even 
# though we are setting then so this is a hack to force the entrypoint.sh 
# to get the variables from the optionsettings
newexports=$(cat $PWD/.optionsettings/$ENVIRONMENT.json | jq -r '.[] | select(.Namespace=="aws:elasticbeanstalk:application:environment") | "export \(.OptionName)=${\(.OptionName):-\(.Value)}"')
newexports=$(printf '%s\n' "$newexports" | sed 's,[\/&],\\&,g;s/$/\\/')
newexports=${newexports%?}
sed 's@\#\# import \#\#@'"${newexports}"'@g' entrypoint.sh > temp.sh && mv temp.sh entrypoint.sh

eb deploy $ENVIRONMENT

# The .config and env.yaml files simply aren't enough to apply the config changes
# this however does the job
aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT --application-name $APPLICATION --region $AWS_REGION --option-settings file://$PWD/.optionsettings/$ENVIRONMENT.json