# Overview

This repository contains a collection of GCP Next demos and samples used in Knative technical session called [Knative platform for your functions, apps, and containers](https://cloud.withgoogle.com/next18/sf/sessions/session/156847).

## Setup

To run these samples you need to follow Knative [install](https://github.com/knative/docs/tree/master/install) steps and post-install cluster configuration instrcutions for both [assigning a static IP](https://github.com/knative/docs/blob/master/serving/gke-assigning-static-ip-address.md) and [setting up a custom domain](https://github.com/knative/docs/blob/master/serving/using-a-custom-domain.md).

After you installed and configured Knative, run the `scripts/demo-setup.sh` script to re-initialize the Knative system to make sure you can run these demos.

## Demos

Follow these instructions to run the demos in the presentation:

* [Deploying and image](image-deploy/README.md)
* [Routing and managing traffic with blue/green deployment](blue-green-deploy/README.md)
* [Automatic scaling and sizing workloads](auto-scaling/README.md)
* [Orchestrating source-to-URL workflows](src-to-url/README.md)
* [Binding running services to eventing ecosystems](event-flow/README.md)


## Monitoring

Run the following command to watch your Kubernetes pods:

```shell
kubectl port-forward -n monitoring \
    $(kubectl get pods -n monitoring --selector=app=grafana --output=jsonpath="{.items..metadata.name}") \
    3000
```
