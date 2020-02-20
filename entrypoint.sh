#!/usr/bin/env bash
set -e

get_parameter() {
    echo "$(aws ssm get-parameter --name "/config/$RAILS_ENV/vbios-platform/$1" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)"
}

export DATABASE_URL=$(get_parameter "DATABASE_URL")
export RAILS_MASTER_KEY=$(get_parameter "RAILS_MASTER_KEY")
export SECRET_KEY_BASE=$(get_parameter "SECRET_KEY_BASE")
export PUBLISHABLE_KEY=$(get_parameter "PUBLISHABLE_KEY")
export SECRET_KEY=$(get_parameter "SECRET_KEY")
export MAILGUN_API_KEY=$(get_parameter "MAILGUN_API_KEY")

printenv >> '/tmp/sample-app/printenv-app.log'

exec python /tmp/application.py