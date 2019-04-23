# Knative demos

<img src ="./images/logo.png" align="left" />

This repository contains a collection of demos used in the different Knative technical sessions (e.g. [One platform for your functions, apps, and containers](https://www.youtube.com/watch?v=F4_2gxTtLaQ)). For list of official Knative samples see the [docs](https://github.com/knative/docs/tree/master/eventing/samples) repository.

To run these samples you need to follow Knative [install](https://github.com/knative/docs/tree/master/install) steps and post-install cluster configuration instructions for both [assigning a static IP](https://github.com/knative/docs/blob/master/serving/gke-assigning-static-ip-address.md) and [setting up a custom domain](https://github.com/knative/docs/blob/master/serving/using-a-custom-domain.md).

## Demos

Follow these instructions to run the demos in the presentation:

* [Deploying an image](simple/)
* [Routing and managing traffic with blue/green deployment](blue-green-deploy/)
* [Orchestrating source-to-URL workflows](src-to-url/)
* [On-cluster Java/Kotlin/Groovy/Scala build and deploy using Jib](jib-build/)
* [Binding running services to an IoT core](iot-events/)
* [Knative Serverless Contract Test](test/)
* [Knative Eventing Twitter/Service/Firestore](eventing-twitter-firebase/)

## Monitoring

> Note, the monitoring/observability components require [additional install](https://github.com/knative/docs/blob/master/serving/installing-logging-metrics-traces.md)

Run the following command to watch your Kubernetes pods while running the demos:

```shell
kubectl port-forward -n knative-monitoring  \
    $(kubectl get pods -n knative-monitoring --selector=app=grafana \
    --output=jsonpath="{.items..metadata.name}") 3000
```
