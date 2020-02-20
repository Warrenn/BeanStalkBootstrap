#!/usr/bin/env bash
set -e

export DATABASE_URL=$(aws ssm get-parameter --name "/config/staging/vbios-platform/DATABASE_URL" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)
export RAILS_MASTER_KEY=$(aws ssm get-parameter --name "/config/staging/vbios-platform/RAILS_MASTER_KEY" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)
export SECRET_KEY_BASE=$(aws ssm get-parameter --name "/config/staging/vbios-platform/SECRET_KEY_BASE" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)
export PUBLISHABLE_KEY=$(aws ssm get-parameter --name "/config/staging/vbios-platform/PUBLISHABLE_KEY" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)
export SECRET_KEY=$(aws ssm get-parameter --name "/config/staging/vbios-platform/SECRET_KEY" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)
export MAILGUN_API_KEY=$(aws ssm get-parameter --name "/config/staging/vbios-platform/MAILGUN_API_KEY" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)

printenv >> '/tmp/sample-app/printenv-app.log'

exec python /tmp/application.py