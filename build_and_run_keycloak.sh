#!/bin/bash

# Name of the Docker image
IMAGE_NAME="axsoter-id-image"
# Port to expose (PLEASE DONT CHANGE)
PORT=8080

# Build the Docker image
echo "Building the Docker image..."
docker build -t $IMAGE_NAME .

# Run the Docker container
echo "Running the Docker container..."
docker run -p $PORT:$PORT $IMAGE_NAME
