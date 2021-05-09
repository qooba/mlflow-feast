#!/bin/bash

docker build -t qooba/mlflow:dev .

docker build -t qooba/mlflow:serving -f Dockerfile.serving .
