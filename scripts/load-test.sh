#!/bin/bash

QUEUE_NAME="nodejs-queue"
RABBITMQ_HOST="localhost"
RABBITMQ_USER="admin"
RABBITMQ_PASS="admin"

# Kuyruğa mesaj gönderme
for i in {1..100}; do
  curl -u $RABBITMQ_USER:$RABBITMQ_PASS -X POST -d "message $i" \
    http://$RABBITMQ_HOST:15672/api/exchanges/%2f/amq.default/publish \
    -H "Content-Type: application/json" \
    -d '{
          "properties":{},
          "routing_key":"'"$QUEUE_NAME"'",
          "payload":"Test message '"$i"'",
          "payload_encoding":"string"
        }'
  sleep 0.5
done
