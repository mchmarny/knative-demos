# Demo deploy using manifest on GitHub with repo

In this demo we will deploy a from GitHub repo our [Simaple App](https://github.com/mchmarny/simple-app) to Knative cluster. Knative will automatically build and deploy the source for us


```bash
kubectl apply -f src-to-url/app.yaml
```

Wait for the created ingress to obtain a public IP...

```bash
watch kubectl get pods
```

Navigate to the `src-to-url` URL (http://src-to-url.default.project-serverless.com/)


## Cleanup


```bash
kubectl delete -f src-to-url/app.yaml
```
