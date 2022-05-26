#!/bin/bash

logFile="/var/log/updateServerIP.log"
touch $logFile

ipcheck() {
  isdiff=1
  ipaddressnew=$(dig +short myip.opendns.com @resolver1.opendns.com)
  for host in ${hostlist[@]}; do
    echo "Running for $host.$domain"
    if [ $host == "@" ]; then
      ipaddresscurrent=$(nslookup $domain 8.8.8.8 | grep Address | grep -v "#" | cut -f2 -d" ")
    else
      ipaddresscurrent=$(nslookup $host.$domain 8.8.8.8 | grep Address | grep -v "#" | cut -f2 -d" ")
    fi
    diffcheck=$(echo $ipaddresscurrent | grep -c $ipaddressnew)

    message="$host.$domain has IP address: $ipaddresscurrent and previously it was $ipaddressnew"
    echo "$message"

    if [ $diffcheck -eq 0 ]; then
      isdiff=0
      echo "IP address has changed for $host."
    else
      echo "IP address has not changed for $host."
    fi
  done
}

update() {
  #hostlist=$1
  for host in ${hostlist[@]}; do
    echo $host
    echo $(curl https://dynamicdns.park-your-domain.com/update?host=$host\&domain=$domain\&password=$APIKEY\&ip=$ipaddressnew)
    response=$(curl https://dynamicdns.park-your-domain.com/update?host=$host\&domain=$domain\&password=$APIKEY\&ip=$ipaddressnew)
    errorcount=$(echo $response | perl -pe "s/.*\<errcount\>(\d+)\<\/ErrCount\>.*/\$1/gi")
    message="Updated IP Address $host.$2 from $ipaddresscurrent to $ipaddressnew"
    echo "$message"
  done
}

# --------------------------------
# ------ BEGIN HOST DEFINITION ---
# --------------------------------
isdiff='1'
# --------------------------------
echo "APIKEY is $APIKEY"
echo "subdomain(s) are/is $SUBDOMAIN"
echo "domain is $DOMAIN"
hostlist=("$SUBDOMAIN")
domain=("$DOMAIN")
password=("$APIKEY")
# --------------------------------
ipcheck $domain $hostlist
if [ $isdiff -eq 0 ]; then
  update $hostlist $domain $password
fi
# --------------------------------
# -------- END HOST DEFINITION ---
# --------------------------------

exit 0
