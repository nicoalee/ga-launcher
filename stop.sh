#!/bin/bash

set -x

id=$(cat container.id)
docker stop $id
docker rm $id
