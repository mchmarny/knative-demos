# Demo: Scale

## Deploying Demo

Deploy Knative service:

```shell
kubectl apply -f app.yaml
```


## Load Generation

Use [fortio](https://github.com/fortio/fortio)

```shell
fortio load -t 1m -c 20 -qps 3 https://scale.demo.knative.tech/v1/prime/9876543
```

In other terminal window

> For best results run this from different network (cloud VM?)

```shell
watch kubectl get pods -n demo -l serving.knative.dev/service=scale
```

## Concurrency

Knative provides `containerConcurrency` which is the maximum number of concurrent requests being handled by a single instance of container. The default value is 0, which means that the system decides.

```yaml
spec:
    containerConcurrency: 1
```

## Cleanup

To delete the demo app, enter the following commands:

```
kubectl delete -f app.yaml
```
