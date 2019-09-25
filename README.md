# Knative demos

<img src ="./images/logo.png" align="left" />

This repository contains a collection of demos used in the different Knative technical sessions (e.g. [One platform for your functions, apps, and containers](https://www.youtube.com/watch?v=F4_2gxTtLaQ)). For list of official Knative samples see the [docs](https://github.com/knative/docs/tree/master/eventing/samples) repository.

To run these samples you need to follow Knative [install](https://github.com/knative/docs/tree/master/install) steps and post-install cluster configuration instructions for both [assigning a static IP](https://github.com/knative/docs/blob/master/serving/gke-assigning-static-ip-address.md), [setting up a custom domain](https://github.com/knative/docs/blob/master/serving/using-a-custom-domain.md), and [configuring outbound network access](https://github.com/knative/docs/blob/master/docs/serving/outbound-network-access.md)

## Setup

> Not fully documented yet but for quick Knative setup on GCP see the [cluster-setup](cluster-setup/)

## Demos

Follow these instructions to run the demos in the presentation:

* Deploying a pre-build image
  * [Using kubectl](simple-kubectl-deploy/)
  * [Using kn CLI](kn-cli-deploy/)
* On-cluster build using Tekton
  * [Csharp build using Kaniko](tekton-kaniko-build/)
  * [Java/Kotlin/Groovy/Scala build using Jib](tekton-jib-build/)
* Configuring Knative application
  * [Automatic scaling](autoscaling/)
  * [Limit RAM/CPU resources or require GPU](container-resource/)
* Operations (Day 2)
  * [Traffic splitting, blue/green updates](traffic-splitting/)
* Eventing
  * [Processing IoT core events](eventing-iot/)
  * [Twitter processing pipelines](eventing-twitter/)

## Monitoring

> Note, the monitoring/observability components require [additional install](https://github.com/knative/docs/blob/master/serving/installing-logging-metrics-traces.md)

Run the following command to watch your Kubernetes pods while running the demos:

```shell
kubectl port-forward -n knative-monitoring  \
    $(kubectl get pods -n knative-monitoring --selector=app=grafana \
    --output=jsonpath="{.items..metadata.name}") 3000
```
