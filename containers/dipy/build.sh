set -e
set -x
docker build -t brainlife/ga-dipy .
docker tag brainlife/ga-dipy brainlife/ga-dipy:1.0
docker push brainlife/ga-dipy
