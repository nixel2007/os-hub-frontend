docker build --tag hub .
docker rm -f hub
docker run -p 3123:5000 --name hub --rm hub
