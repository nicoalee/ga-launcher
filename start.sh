#!/bin/bash

rm -f pull.log

set -e

#I need to point to the right api server based on the environment we are in
host=brainlife.io
[ $HOSTNAME == "dev1.soichi.us" ] && host=dev1.soichi.us
[ $HOSTNAME == "ga-test" ] && host=test.brainlife.io

#jwt=$(cat $WAREHOUSE_JWT)

group_id=$(jq -r .group config.json)
container=$(jq -r .container config.json)

#validate container name
case "$container" in
jupyter/*)
    echo "accepted.. jupyter container"
    ;;
brainlife/*)
    echo "accepted.. brainlife container"
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
        #'Access-Control-Allow-Origin': "*",
        #'Access-Control-Allow-Credentials': "true",
        #'Access-Control-Allow-Methods': "OPTIONS",
        'Content-Security-Policy': "frame-ancestors self http://localhost:8080 https://dev1.soichi.us https://brainlife.io https://test.brainlife.io"
  }
}

# TODO - we need to secure by generated token for each jupyterhub instance, but also with token from brainlife jwt as specific user
# The secrect key used to generate the given token
#c.JSONWebTokenAuthenticator.secret = '$JWT_PUBLIC_KEY'
#c.JSONWebTokenAuthenticator.username_claim_field = 'sub'
#c.JSONWebTokenAuthenticator.expected_audience = '$JWT_ISSUER'
#
# This will enable local user creation upon authentication, requires JSONWebTokenLocalAuthenticator
##c.JSONWebLocalTokenAuthenticator.create_system_users = True                       
EOF

mkdir -p home
chmod 777 home
cp .bashrc home/

projectid=$(jq -r .project._id config.json)

input_mount=""
if [ -d /mnt/secondary/$group_id ]; then
    input_mount="-v /mnt/secondary/$group_id:/home/jovyan/input:ro,shared"
fi

#for ui
cat <<EOF > container.json
{
    "port": $port,
    "token": "$token"
}
EOF

name=$group_id.$TASK_ID
docker rm -f $name || true

echo "git clone notebook requested"
git clone https://github.com/soichih/ga-test.git home/app

echo "starting container - might take a while for the first time"
nohup docker run \
    --name $name \
    --restart=always \
    -v `pwd`/home:/home/brlife \
    -v `pwd`/config.json:/home/brlife/config.json \
    $input_mount \
    -v `pwd`/jupyter_notebook_config.py:/etc/jupyter/jupyter_notebook_config.py \
    -p $port:8080 \
    --memory=16g \
    --cpus=4 \
    -d $container > container.id 2> pull.log &

