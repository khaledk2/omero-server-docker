#!/bin/bash

set -e
set -u

PREFIX=test
IMAGE=omero-server:$PREFIX

CLEAN=${CLEAN:-y}

cleanup() {
    docker logs $PREFIX-server
    docker rm -f -v $PREFIX-db $PREFIX-server
}

if [ "$CLEAN" = y ]; then
    trap cleanup ERR EXIT
fi

cleanup || true

echo "building the docker image: $IMAGE"
docker build -t $IMAGE  .
echo "image has been built, goint to run the docker container  ====>>>>"
docker run -d --name $PREFIX-db -e POSTGRES_PASSWORD=postgres postgres:16
echo "docker container has been run, $PREFIX-db"

# Check both CONFIG_environment and *.omero config mounts work
docker run -d --name $PREFIX-server --link $PREFIX-db:db \
    -p 4064 \
    -e CONFIG_omero_db_user=postgres \
    -e CONFIG_omero_db_pass=postgres \
    -e CONFIG_omero_db_name=postgres \
    -e CONFIG_custom_property_fromenv=fromenv \
    -e ROOTPASS=omero-root-password \
    -v $PWD/test-config/config.omero:/opt/omero/server/config/config.omero:ro \
    $IMAGE

echo "Container $PREFIX-server has been run for $IMAGE"
# Smoke tests
echo "Testing is going to be performed ..."
export OMERO_USER=root
export OMERO_PASS=omero-root-password
export PREFIX

sleep 160

# Login to server
echo "testing login ===>>>"
bash test_login.sh
echo "testing config ...... ===>>>"
sleep 60
# Check the Docker OMERO configuration system
bash test_config.sh
sleep 60
# Wait a minute to ensure other servers are running

# Now that we know the server is up, test Dropbox

echo "test test_dropbox ====>>>>>>>"
bash test_dropbox.sh
sleep 60
# And Processor (slave-1)
echo "testing test_processor =============+>>>"
bash test_processor.sh
