
#set -e
#set -x

#docker build -t brainlife/ga-dipy .
#docker tag brainlife/ga-dipy brainlife/ga-dipy:lab3016-dipy130
#docker push brainlife/ga-dipy

docker build -t brainlife/ga-python .
docker tag brainlife/ga-python brainlife/ga-python:lab328-dipy141-pybrainlife-1.0
docker push brainlife/ga-python:lab328-dipy141-pybrainlife-1.0
