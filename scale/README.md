# Demo: Scale

## Deploying Demo

Deploy Knative service:

`kubectl apply -f app.yaml`


## Load Generation

Use [fortio](https://github.com/fortio/fortio)

```shell
fortio load -t 1m -c 20 -qps 3 https://scale.demo.knative.tech/prime/50000000
```

In other terminal window

```shell
watch kubectl get pods -n demo
```


## Cleanup

To delete the demo app, enter the following commands:

```
kubectl delete -f app.yaml
```
