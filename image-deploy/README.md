# Simple image deploy using Service

In this demo we will deploy a pre-built docker image of [simple-app](https://github.com/mchmarny/simple-app) to Knative cluster.


```bash
kubectl apply -f image-deploy/app.yaml
```

Wait for the created ingress to obtain a public IP...

```bash
watch kubectl get pods
```

Navigate to the http://simple.default.project-serverless.com/ to see results

## Cleanup


```bash
kubectl delete -f image-deploy/app.yaml
```
