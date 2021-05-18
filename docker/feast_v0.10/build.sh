#!/bin/bash

docker build -t qooba/feast:v0.10 .
docker build -t qooba/feast:mlflow-feast .

docker build -f Dockerfile.dev -t qooba/feast:dev .

