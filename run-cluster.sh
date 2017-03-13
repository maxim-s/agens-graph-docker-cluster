#!/bin/bash 

echo "cleaning up ..."

SERVICE_NAME=master

VOLUME_NAME=$SERVICE_NAME-volume

docker service rm $SERVICE_NAME

SERVICE_NAME=replica1
VOLUME_NAME=$SERVICE_NAME-volume

docker service rm $SERVICE_NAME

SERVICE_NAME=replica2
VOLUME_NAME=$SERVICE_NAME-volume

docker service rm $SERVICE_NAME

SERVICE_NAME=replica3
VOLUME_NAME=$SERVICE_NAME-volume

docker service rm $SERVICE_NAME

echo "starting agens-graph master container..."

MASTER_SERVICE_NAME=master

docker service create \
 --mount type=volume,src=$MASTER_SERVICE_NAME-volume,dst=/agens-graph/data,volume-driver=local \
 --name $MASTER_SERVICE_NAME \
 --network agensgraphnet \
 --constraint 'node.labels.type == master' \
 --env PGHOST=/tmp \
 --env PG_USER=testuser \
 --env PG_MODE=master \
 --env PG_MASTER_USER=master \
 --env PG_ROOT_PASSWORD=password \
 --env PG_PASSWORD=password \
 --env PG_DATABASE=userdb \
 --env PG_MASTER_PORT=5432 \
 --env PG_MASTER_PASSWORD=password \
 maxims/agens-graph-docker

echo "sleep for a bit before starting the replica..."

sleep 30

SERVICE_NAME=replica1
VOLUME_NAME=$SERVICE_NAME-volume


docker service create \
 --mount type=volume,src=$VOLUME_NAME,dst=/agens-graph/data,volume-driver=local \
 --name $SERVICE_NAME \
 --network agensgraphnet \
 --constraint 'node.labels.type != master' \
 --env PGHOST=/tmp \
 --env PG_USER=testuser \
 --env PG_MODE=slave \
 --env PG_MASTER_USER=master \
 --env PG_ROOT_PASSWORD=password \
 --env PG_PASSWORD=password \
 --env PG_DATABASE=userdb \
 --env PG_MASTER_PORT=5432 \
 --env PG_MASTER_PASSWORD=password \
 --env PG_MASTER_HOST=$MASTER_SERVICE_NAME \
 maxims/agens-graph-docker
 
 
SERVICE_NAME=replica2
VOLUME_NAME=$SERVICE_NAME-volume


docker service create \
 --mount type=volume,src=$VOLUME_NAME,dst=/agens-graph/data,volume-driver=local \
 --name $SERVICE_NAME \
 --network agensgraphnet \
 --constraint 'node.labels.type != master' \
 --env PGHOST=/tmp \
 --env PG_USER=testuser \
 --env PG_MODE=slave \
 --env PG_MASTER_USER=master \
 --env PG_ROOT_PASSWORD=password \
 --env PG_PASSWORD=password \
 --env PG_DATABASE=userdb \
 --env PG_MASTER_PORT=5432 \
 --env PG_MASTER_PASSWORD=password \
 --env PG_MASTER_HOST=$MASTER_SERVICE_NAME \
 maxims/agens-graph-docker
 
 SERVICE_NAME=replica3
VOLUME_NAME=$SERVICE_NAME-volume


docker service create \
 --mount type=volume,src=$VOLUME_NAME,dst=/agens-graph/data,volume-driver=local \
 --name $SERVICE_NAME \
 --network agensgraphnet \
 --constraint 'node.labels.type != master' \
 --env PGHOST=/tmp \
 --env PG_USER=testuser \
 --env PG_MODE=slave \
 --env PG_MASTER_USER=master \
 --env PG_ROOT_PASSWORD=password \
 --env PG_PASSWORD=password \
 --env PG_DATABASE=userdb \
 --env PG_MASTER_PORT=5432 \
 --env PG_MASTER_PASSWORD=password \
 --env PG_MASTER_HOST=$MASTER_SERVICE_NAME \
 maxims/agens-graph-docker
