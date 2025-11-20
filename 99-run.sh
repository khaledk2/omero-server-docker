#!/bin/bash

set -eu

omero=/opt/omero/server/venv3/bin/omero
cd /opt/omero/server
echo "test from here..."
echo "Starting OMERO.server"
echo "$omero"
output=$($omero admin start --foreground)
echo "The output is:"
echo "$output"
#exec $omero admin start --foreground
echo "DONE !"