#!/usr/bin/env bash
set -e

export ACCESS_KEY_ID=ACCESS_KEY_ID
export SECRET_ACCESS_KEY=SECRET_ACCESS_KEY
export PUBLISHABLE_KEY=PUBLISHABLE_KEY
export SECRET_KEY=SECRET_KEY
export DATABASE_URL=$(aws ssm get-parameter --name "/Config/Staging/vbios-platform/DATABASE_URL" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)
export RAILS_MASTER_KEY=RAILS_MASTER_KEY
export SECRET_KEY_BASE=SECRET_KEY_BASE

printenv >> '/tmp/sample-app/printenv-app.log'

exec python /tmp/application.py