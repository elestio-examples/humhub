#!/usr/bin/env bash

rm docker-compose.yml
mv docker-compose-new.yml docker-compose.yml

HUMHUB_VERSION="$(awk '$0 ~ /^([0-9\.]+) [0-9\.]+ latest/ {print $1}' versions.txt)"
VCS_REF="$(git rev-parse --short HEAD)"

sed -i 's/ARG HUMHUB_VERSION/ARG HUMHUB_VERSION='"${HUMHUB_VERSION}"'/g' Dockerfile
sed -i 's/ARG VCS_REF/ARG VCS_REF='"${VCS_REF}"'/g' Dockerfile

cat /opt/elestio/startPostfix.sh > post.txt
filename="./post.txt"

SMTP_LOGIN=""
SMTP_PASSWORD=""

# Read the file line by line
while IFS= read -r line; do
  # Extract the values after the flags (-e)
  values=$(echo "$line" | grep -o '\-e [^ ]*' | sed 's/-e //')

  # Loop through each value and store in respective variables
  while IFS= read -r value; do
    if [[ $value == RELAYHOST_USERNAME=* ]]; then
      SMTP_LOGIN=${value#*=}
    elif [[ $value == RELAYHOST_PASSWORD=* ]]; then
      SMTP_PASSWORD=${value#*=}
    fi
  done <<< "$values"

done < "$filename"

rm post.txt

cat << EOT >> ./.env

HUMHUB_MAILER_HOSTNAME=tuesday.mxrouting.net
HUMHUB_MAILER_PORT=465
HUMHUB_MAILER_USERNAME=${SMTP_LOGIN}
HUMHUB_MAILER_PASSWORD=${SMTP_PASSWORD}
HUMHUB_MAILER_SYSTEM_EMAIL_ADDRESS=${SMTP_LOGIN}
EOT


docker buildx build . --output type=docker,name=elestio4test/humhub:latest | docker load
