#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;


sed -i "s~DOMAIN_TO_CHANGE~${DOMAIN}~g" ./docker-compose.yml
sed -i "s~172.17.0.1~${IP}~g" ./docker-compose.yml

docker-compose down;
docker-compose up -d;

sleep 30s;