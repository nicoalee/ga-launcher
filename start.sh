#!/bin/bash

set -e
set -x

group_id=$(jq -r .group config.json)
container=$(jq -r .container config.json)

#validate container name
case "$container" in
jupyter/*)
    echo "accepted"
    ;;
*)
    echo "invalid container"
    exit 1
esac

echo "finding open port"
port=$(./find_open_port.py)

token=$(openssl rand -hex 32)

cat <<EOF > jupyter_notebook_config.py
from jupyter_core.paths import jupyter_data_dir

c = get_config()
c.NotebookApp.base_url = '/ipython/$port/'
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8080
c.NotebookApp.open_browser = False
c.NotebookApp.token = '$token'

# https://github.com/jupyter/notebook/issues/3130
#c.FileContentsManager.delete_to_trash = False

c.NotebookApp.tornado_settings = {
  'headers': {
        #'Content-Security-Policy': "frame-ancestors *"
        'Content-Security-Policy': "frame-ancestors self http://localhost:8080 https://dev1.soichi.us https://brainlife.io https://test.brainlife.io"
  }
}
EOF

mkdir -p home
chmod 777 home

echo "starting container"
#--network host \
docker run \
    --restart=always \
    -v /mnt/secondary/$group_id:/home/jovyan/input:ro \
    -v `pwd`/home:/home/jovyan \
    -v `pwd`/jupyter_notebook_config.py:/etc/jupyter/jupyter_notebook_config.py \
    -p $port:8080 \
    -d $container > container.id

cat <<EOF > container.json
{
    "id": "$(cat container.id)",
    "port": $port,
    "token": "$token"
}
EOF


