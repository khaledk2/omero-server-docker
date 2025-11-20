#!/bin/bash

set -eu

omero=/opt/omero/server/venv3/bin/omero
cd /opt/omero/server
echo "test from here..."
echo "Starting OMERO.server"
echo "$omero"
exec $omero admin start --foreground
echo "DONE !"