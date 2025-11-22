#!/bin/bash

/opt/omero/server/venv3/bin/pip install setuptools

set -eu

omero=/opt/omero/server/venv3/bin/omero
cd /opt/omero/server
echo "Starting OMERO.server"
exec $omero admin start --foreground
