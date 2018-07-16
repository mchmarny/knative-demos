#!/bin/bash

# blue/green
kubectl delete -f blue-green-deploy/stage4.yaml --ignore-not-found=true
kubectl delete -f blue-green-deploy/stage3.yaml --ignore-not-found=true
kubectl delete -f blue-green-deploy/stage2.yaml --ignore-not-found=true
kubectl delete -f blue-green-deploy/stage1.yaml --ignore-not-found=true

# flow
kubectl delete -f event-flow/flow.yaml --ignore-not-found=true

# service
kubectl delete -f image-deploy/app.yaml --ignore-not-found=true

# src to url
kubectl delete -f src-to-url/app.yaml --ignore-not-found=true