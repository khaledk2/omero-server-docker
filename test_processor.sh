#!/bin/bash

set -e
set -u
set -x

# Must be exported by the caller:
# OMERO_USER OMERO_PASS PREFIX

OMERO=/opt/omero/server/venv3/bin/omero
DSNAME=$(date +%Y%m%d-%H%M%S-%N)
FILENAME=$(date +%Y%m%d-%H%M%S-%N).fake
SCRIPT=/omero/util_scripts/Dataset_To_Plate.py
SERVER="localhost:4064"
echo "111111111111111111111111111111"
dataset_id=$(docker exec $PREFIX-server $OMERO obj -q -s $SERVER -u $OMERO_USER -w $OMERO_PASS new Dataset name=$DSNAME | cut -d: -f2)
echo "2222222222222222222222222222222"
docker exec $PREFIX-server sh -c \
    "touch /tmp/$FILENAME && $OMERO import -d $dataset_id /tmp/$FILENAME"
echo "3333333333333333333333333333333"
containers=docker ps
stopped_containers=docker ps -a
echo "$containers"
echo "$stopped_containers"

docker exec $PREFIX-server $OMERO script launch $SCRIPT IDs=$dataset_id
echo "44444444444444444444444444444444"
echo "Completed with code $?"
echo "55555555555555555555555555555555555"
result=$(docker exec $PREFIX-server $OMERO hql -q -s $SERVER -u $OMERO_USER -w $OMERO_PASS "SELECT COUNT(w) FROM WellSample w WHERE w.well.plate.name='$DSNAME' AND w.image.name='$FILENAME'" --style plain)
echo "display results ============>>>>"
echo $result
echo "<<<<<<<<<<<<<<<<<<<results ============>>>>"
if [ "$result" != "0,1" ]; then
    echo "Script failed: $result"
    exit 2
fi
