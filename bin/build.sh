#!/bin/sh -e

# Compiles the vendor/bundle directory to deploy the code
# in the AWS Lambda function using the native extensions
docker build -t ruby-builder -f Dockerfile .
CONTAINER=$(docker run -d ruby-builder)

docker cp $CONTAINER:/var/task/vendor .

docker stop $CONTAINER
docker rm $CONTAINER
