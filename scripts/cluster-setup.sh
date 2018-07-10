#!/bin/bash

export PROJECT_ID=s9-demo
export CLUSTER_NAME=knative
export CLUSTER_REGION=us-west1
export CLUSTER_ZONE="${CLUSTER_REGION}-c"
export GCE_NODE_TYPE=n1-standard-4


echo "Setting project..."
gcloud config set project $PROJECT_ID

echo "Enable APIs..."
gcloud services enable \
  cloudapis.googleapis.com \
  container.googleapis.com \
  containerregistry.googleapis.com


echo "Deleteing previous cluster..."
gcloud container clusters delete $CLUSTER_NAME --quiet


echo "Creating new cluster..."
gcloud container clusters create $CLUSTER_NAME \
  --zone=$CLUSTER_ZONE \
  --cluster-version latest \
  --machine-type $GCE_NODE_TYPE \
  --num-nodes 3 \
  --enable-autoscaling --min-nodes=1 --max-nodes=10 \
  --scopes=cloud-platform,logging-write,monitoring-write,pubsub


echo "Getting credentials to new cluster..."
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value core/account)


echo "Deploy Istio..."
kubectl apply -f https://storage.googleapis.com/knative-releases/latest/istio.yaml
kubectl label namespace default istio-injection=enabled

echo "Waiting for Istio to start..."
sleep 5 # //TODO: Chnage that to watch object

echo "Install Knative..."
kubectl apply -f https://storage.googleapis.com/knative-releases/latest/release.yaml

echo "Waiting for Istio to start..."
sleep 5 # //TODO: Chnage that to watch object

echo "Setting external IP..."
gcloud compute addresses create "${CLUSTER_NAME}-external-ip" --region $CLUSTER_REGION
