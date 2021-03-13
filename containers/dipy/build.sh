docker pull jupyter/datascience-notebook:lab-2.1.1

set -e
set -x

docker build -t brainlife/ga-dipy .
docker tag brainlife/ga-dipy brainlife/ga-dipy:lab211-dipy130
docker push brainlife/ga-dipy
