# Knative Demos

<table border="0">
    <tr>
        <td>
            <img src ="images/logo.png" width="100"/>
        </td>
        <td>
            This repository contains a collection of demos I use in different technical Knative  sessions (e.g. [Generating Events from Your Internal Systems with Knative](https://www.youtube.com/watch?v=riq0x5xdfNg)). For the complete list of official Knative samples see [docs](https://github.com/knative/docs/tree/master/eventing/samples) repository.
        </td>
    </tr>
</table>

## Setup

To run these samples you need to a Knative cluster. If you don't have one, you can use the quick [setup](setup/) steps for GKE including static IP, custom domain and a few other post install configurations.

> For official documentation on how to install and configure Knative on variety of Kubernetes services see the [Knative install documentation](https://github.com/knative/docs/tree/master/docs/install)

## Demos

Follow these instructions to run the demos in the presentation:

* Deploying a pre-build image
  * [Using kubectl](simple-kubectl-deploy/)
  * [Using kn CLI](kn-cli-deploy/)
* On-cluster build using Tekton
  * [Csharp build using Kaniko](tekton-kaniko-build/)
  * [Java/Kotlin/Groovy/Scala build using Jib](tekton-jib-build/)
* Configuring Knative application
  * [Internal (cluster-local) services](service-internal/)
  * [Automatic scaling](autoscaling/)
  * [Limit RAM/CPU resources or require GPU](service-config/)
* Operations (Day 2)
  * [Traffic splitting, blue/green updates](traffic-splitting/)
* Eventing
  * [Processing IoT core events](eventing-iot/)
  * [Twitter processing pipelines](eventing-pipeline/)

## Monitoring

> Note, the monitoring/observability components require [additional install](https://github.com/knative/docs/blob/master/serving/installing-logging-metrics-traces.md)

Run the following command to watch your Kubernetes pods while running the demos:

```shell
kubectl port-forward -n knative-monitoring  \
    $(kubectl get pods -n knative-monitoring --selector=app=grafana \
    --output=jsonpath="{.items..metadata.name}") 3000
```
