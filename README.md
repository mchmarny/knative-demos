# Knative demos

![image alt >](./images/logo.png)

This repository contains a collection of Knative demos used in the [Knative](https://github.com/knative) technical session called "One platform for your functions, apps, and containers" ([slides](slides/knative-gcp-next18-one-platform-for-your-functions-applications-containers.pdf),[video](https://www.youtube.com/watch?v=F4_2gxTtLaQ)).

## Setup

To run these samples you need to follow Knative [install](https://github.com/knative/docs/tree/master/install) steps and post-install cluster configuration instructions for both [assigning a static IP](https://github.com/knative/docs/blob/master/serving/gke-assigning-static-ip-address.md) and [setting up a custom domain](https://github.com/knative/docs/blob/master/serving/using-a-custom-domain.md).

## Demos

Follow these instructions to run the demos in the presentation:

* [Deploying an image](simple/README.md)
* [Routing and managing traffic with blue/green deployment](blue-green-deploy/README.md)
* [Orchestrating source-to-URL workflows](src-to-url/README.md)
* [On-cluster Java/Kotlin/Groovy/Scala build and deploy using Jib](jib-build/README.md)
* [Binding running services to an IoT core](iot-events/README.md)
* [Knative Serverless Contract Test](test/README.md)

## Monitoring

> Note, the monitoring/observability components require [additional install](https://github.com/knative/docs/blob/master/serving/installing-logging-metrics-traces.md)

Run the following command to watch your Kubernetes pods while running the demos:

```shell
kubectl port-forward -n knative-monitoring  \
    $(kubectl get pods -n knative-monitoring --selector=app=grafana \
    --output=jsonpath="{.items..metadata.name}") 3000
```
