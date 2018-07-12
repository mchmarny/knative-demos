#!/bin/bash

# advanced
kubectl delete -f advanced-deploy/stage4.yaml --ignore-not-found=true
kubectl delete -f advanced-deploy/stage3.yaml --ignore-not-found=true
kubectl delete -f advanced-deploy/stage2.yaml --ignore-not-found=true
kubectl delete -f advanced-deploy/stage1.yaml --ignore-not-found=true

# bind
kubectl delete -f event-bind/bind.yaml --ignore-not-found=true

# service
kubectl delete -f service-deploy/app.yaml --ignore-not-found=true

# src to url
kubectl delete -f src-to-url/app.yaml --ignore-not-found=true