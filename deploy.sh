#!/bin/bash

set -e

export PATH="/root/.ebcli-virtual-env/executables:$PATH"

newexports=$(cat $PWD/.optionsettings/$ENVIRONMENT.json | jq -r '.[] | select(.Namespace=="aws:elasticbeanstalk:application:environment") | "export \(.OptionName)=${\(.OptionName):-\(.Value)}"')
newexports=$(printf '%s\n' "$newexports" | sed 's,[\/&],\\&,g;s/$/\\/')
newexports=${newexports%?}

sed 's@\#\# import \#\#@'$newexports'@g' entrypoint.sh > entrypoint.sh
eb deploy $ENVIRONMENT

aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT --application-name $APPLICATION --region $AWS_REGION --option-settings file://$PWD/.optionsettings/$ENVIRONMENT.json