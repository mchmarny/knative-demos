# Overview

Collection of GCP Next demos and samples used in Knative technical session called [Knative platform for your functions, apps, and containers](https://cloud.withgoogle.com/next18/sf/sessions/session/156847).

## Setup

To run these samples you will need to follow Knative [install](https://github.com/knative/docs/tree/master/install) steps and post-install cluster configuration instrcutions for both [assigning static IP](https://github.com/knative/docs/blob/master/serving/gke-assigning-static-ip-address.md) and [setting custom domain](https://github.com/knative/docs/blob/master/serving/using-a-custom-domain.md).

To setup/reset the demos to correct state, run `scripts/demo-setup.sh` script which will re-initialize the Knative system.

## Demos

* [image-deploy](image-deploy/README.md)
* [blue-green-deploy](blue-green-deploy/README.md)
* [auto-scaling](auto-scaling/README.md)
* [src-to-url](src-to-url/README.md)
* [event-flow](event-flow/README.md)


## Monitoring

```shell
kubectl port-forward -n monitoring \
    $(kubectl get pods -n monitoring --selector=app=grafana --output=jsonpath="{.items..metadata.name}") \
    3000
```