#!/bin/bash
cd /root/

docker stack rm root

while ! docker stack deploy --compose-file docker-compose.yml root
do
    printf "\nWaiting to start SkyCRM"
    sleep 2
done