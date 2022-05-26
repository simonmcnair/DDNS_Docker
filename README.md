# DDNS_Docker
Docker container to update DDNS for namecheap.  Essentially a wrapper around https://www.dlford.io/hosting-on-the-web-how-to-home-lab-part-6/

docker build --no-cache -t mytagname:v1 build

docker run --name DDNS -e "APIKEY=apikeyhere" -e "DOMAIN=example.co.uk" -e "SUBDOMAIN=stest1 test2 test3" -d mytagname:v1
