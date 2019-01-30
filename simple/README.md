# Demo: Deploying existing image to Knative

In this demo we will deploy a pre-built docker image of a [simple-app](https://github.com/mchmarny/simple-app) to a Knative cluster.

> Assuming you already configured static IP and custom domain. In this demo we will use `knative.tech`

Simplest way to install images to Knative is using CLI (e.g. [gcloud](https://cloud.google.com/sdk/gcloud/) or [knctl](https://github.com/cppforlife/knctl))

```shell
knctl deploy -n demo -s simple -i gcr.io/knative-samples/simple-app -e SIMPLE_MSG="Hello World"
```

Navigate to https://simple.demo.knative.tech/ to see the results.

> Knative `client` workgroup already kicked off, watch [this repo](https://github.com/knative/client)

## Cleanup

To remove the sample app from your cluster

```shell
knctl service delete --service simple --namespace demo
```
