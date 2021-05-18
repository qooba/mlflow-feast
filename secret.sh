#!/bin/bash


kubectl create secret generic minio-auth -n qooba --from-literal=username=minio --from-literal=password=minio123
