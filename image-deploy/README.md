# Demo: Deploying an image with Knative service

In this demo we will deploy a pre-built docker image of a [simple-app](https://github.com/mchmarny/simple-app) to a Knative cluster.

> Assuming you already configured static IP and custom domain. In this demo we will use `knative.tech`

1. Apply the configuration:

```bash
kubectl apply -f app.yaml
```

Outputs:

```shell
service "simple" created
```

1. Wait for the created ingress to obtain a public IP:

```bash
watch kubectl get pods
```

Should output:

```shell
NAME                                                        READY     STATUS    RESTARTS   AGE
simple-00001-deployment-6d4966dc7c-mz4x2                    3/3       Running   0          6m
```


1. Navigate to https://simple.demo.knative.tech/ to see the results.

## Cleanup

To remove the sample app from your cluster, delete the `.yaml` file:

```bash
kubectl delete -f app.yaml
```

Outputs:

```shell
service "simple" deleted
```
