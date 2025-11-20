#!/bin/bash

set -eu

omero=/opt/omero/server/venv3/bin/omero
cd /opt/omero/server
echo "test from here..."
echo "Starting OMERO.server"
exec $omero admin start --foreground
echo "DONE !"