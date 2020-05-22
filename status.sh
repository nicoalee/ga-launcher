#!/bin/bash

#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed
#return code 3 = unknown (retry later)

if [ ! -f container.id ]; then
    echo "container not yet started?"
    exit 3
fi

id=$(cat container.id)
docker inspect $id > inspect.json
if [ $? -eq 0 ]; then
    echo "running"
    exit 0 #running
else
    echo "not running"
    exit 2 #disappeared?
fi


