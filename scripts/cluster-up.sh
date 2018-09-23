#!/bin/bash

# Config
export PROJECT_ID=s9-demo
export CLUSTER_NAME=knative-11
export CLUSTER_ZONE=us-west1-c

# cluster
gcloud container clusters create $CLUSTER_NAME \
  --zone=$CLUSTER_ZONE \
  --cluster-version=latest \
  --machine-type=n1-standard-4 \
  --enable-autoscaling --min-nodes=1 --max-nodes=10 \
  --enable-autorepair \
  --scopes=cloud-platform,service-control,service-management,compute-rw,storage-ro,logging-write,monitoring-write,pubsub,datastore \
  --num-nodes=3

# cluster admin binding
kubectl create clusterrolebinding cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud config get-value core/account)

# Istio
kubectl apply -f https://raw.githubusercontent.com/knative/serving/v0.1.1/third_party/istio-0.8.0/istio.yaml
kubectl label namespace default istio-injection=enabled

# Wait
# watch kubectl get pods --namespace istio-system


# Knative
kubectl apply -fi https://github.com/knative/serving/releases/download/v0.1.1/release.yaml

# Wait
# watch kubectl get pods --namespace knative-serving
# watch kubectl get pods --namespace knative-build

# Domain
kubectl apply --filename domain.yaml

# Network
export NET_SCOPE=$(gcloud container clusters describe ${CLUSTER_NAME} --zone=${CLUSTER_ZONE} \
                  | grep -e clusterIpv4Cidr -e servicesIpv4Cidr \
                  | sed -e "s/clusterIpv4Cidr://" -e "s/servicesIpv4Cidr://" \
                  | xargs echo | sed -e "s/ /,/")

kubectl patch configmap config-network -n knative-serving -p \
    "{\"data\":{\"istio.sidecar.includeOutboundIPRanges\":\"${NET_SCOPE}\"}}"


