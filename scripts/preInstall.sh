#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./storage/uploads
mkdir -p ./storage/assets
mkdir -p ./storage/modules
mkdir -p ./storage/themes

chown -R 1000:1000 ./storage/uploads
chown -R 1000:1000 ./storage/assets
chown -R 1000:1000 ./storage/modules
chown -R 1000:1000 ./storage/themes

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