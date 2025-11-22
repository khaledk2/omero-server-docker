#!/bin/bash

set -eu

# omero=/opt/omero/server/venv3/bin/omero
omero=/opt/omero/server/OMERO.server/bin/omero

cd /opt/omero/server
echo "Starting OMERO.server"
exec $omero admin start --foreground
echo "OMERO.server has been started ....."
