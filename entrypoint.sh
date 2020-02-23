#!/bin/bash
set -e

get_parameter() {
    echo "$(aws ssm get-parameter --name "/config/$RAILS_ENV/vbios-platform/$1" --region us-east-1 --with-decryption --query 'Parameter.Value' --output text)"
}


if [ -z "${ACCESS_KEY_ID}" ]; then
    ROLENAME=$(curl http://169.254.169.254/latest/meta-data/iam/security-credentials/ -s)
    KeyURL="http://169.254.169.254/latest/meta-data/iam/security-credentials/"$ROLENAME"/"
    wget $KeyURL -q -O Iam.json
    ACCESS_KEY_ID="${ACCESS_KEY_ID:-$(grep -Po '.*"AccessKeyId".*' Iam.json | sed 's/ //g' | sed 's/"//g' | sed 's/,//g' | sed 's/AccessKeyId://g')}"
    SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY:-$(grep -Po '.*"SecretAccessKey".*' Iam.json | sed 's/ //g' | sed 's/"//g' | sed 's/,//g' | sed 's/SecretAccessKey://g')}"
    AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN:-$(grep -Po '.*"Token".*' Iam.json | sed 's/ //g' | sed 's/"//g' | sed 's/,//g' | sed 's/Token://g')}"
    rm Iam.json -f
fi

export DATABASE_URL="${DATABASE_URL:-$(get_parameter "DATABASE_URL")}"
export RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-$(get_parameter "RAILS_MASTER_KEY")}"
export SECRET_KEY_BASE="${SECRET_KEY_BASE:-$(get_parameter "SECRET_KEY_BASE")}"
export PUBLISHABLE_KEY="${PUBLISHABLE_KEY:-$(get_parameter "PUBLISHABLE_KEY")}"
export SECRET_KEY="${SECRET_KEY:-$(get_parameter "SECRET_KEY")}"
export MAILGUN_API_KEY="${MAILGUN_API_KEY:-$(get_parameter "MAILGUN_API_KEY")}"

# Remove a potentially pre-existing server.pid for Rails.
rm -rf /vbio/tmp/pids/server.pid

exec "$@"