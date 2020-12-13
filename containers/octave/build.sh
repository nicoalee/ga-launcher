set -e
set -x
docker build -t brainlife/ga-octave .
docker tag brainlife/ga-octave brainlife/ga-octave:1.0
docker push brainlife/ga-octave
