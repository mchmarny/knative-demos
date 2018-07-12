# Demo deploy using manifest on GitHub with repo

In this demo we will deploy a pre-built sample docker image of an app called `Simaple App` to Knative cluster.


```bash
kubectl apply -f src-to-url/app.yaml
```

Wait for the created ingress to obtain a public IP...

```bash
kubectl get pods --watch
```

Navigate to the `src-to-url` URL.


## Cleanup


```bash
kubectl delete -f src-to-url/app.yaml
```
