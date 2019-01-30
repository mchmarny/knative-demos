# Demo: Deploying existing image to Knative

In this demo we will deploy a pre-built docker image of a [simple-app](https://github.com/mchmarny/simple-app) to a Knative cluster.

> Assuming you already configured static IP and custom domain. In this demo we will use `knative.tech`

## CLI

Simplest way to install images to Knative is using CLI (e.g. [gcloud](https://cloud.google.com/sdk/gcloud/) or [knctl](https://github.com/cppforlife/knctl)). In this example we will use `knctl` originally developed by [cppforlife](https://github.com/cppforlife)

```shell
knctl deploy -n demo -s simple -i gcr.io/knative-samples/simple-app -e SIMPLE_MSG="Hello World"
```

Navigate to https://simple.demo.knative.tech/ to see the results.

> Knative `client` workgroup, including cppforlife already works on official Knative CLI, watch [this repo](https://github.com/knative/client) for updates.

## Manifest

Another way to deploy is to use the Knative `service` manifest (see [./app.yaml]). Simply apply that manifest to your cluster.

```shell
kubectl apply -f app.yaml
```

The deployed app should be available under the same URL (https://simple.demo.knative.tech/)


## Cleanup

To remove the sample app from your cluster

```shell
knctl service delete --service simple --namespace demo
```
or

```shell
kubectl delete -f app.yaml
```
