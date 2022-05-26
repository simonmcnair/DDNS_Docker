FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y dnsutils curl && rm -rf /var/lib/apt/lists/*
COPY ./updateServerIP.sh /app/updateServerIP.sh
CMD while :; /app/updateServerIP.sh; echo "pausing for 1 minute";do sleep 1m ; done
