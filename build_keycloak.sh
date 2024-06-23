#!/bin/bash

# Name of the Docker image
IMAGE_NAME="axsoter-id-image"
# Port to expose (PLEASE DONT CHANGE)
PORT=8080

# Build the Docker image
echo "Building the Docker image..."
docker build -t $IMAGE_NAME .

echo "Done! You can now continue to step 3"
