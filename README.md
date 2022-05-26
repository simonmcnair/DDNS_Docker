# DDNS_Docker

docker build --no-cache -t mytagname:v1 build

docker run --name DDNS -e "APIKEY=apikeyhere" -e "DOMAIN=example.co.uk" -e "SUBDOMAIN=stest1 test2 test3" -d mytagname:v1
