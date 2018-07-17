# WIP: Demo deploy using manifest on GitHub with repo

In this demo we will deploy a from GitHub repo our [Simaple App](https://github.com/mchmarny/simple-app) to Knative cluster. Knative will automatically build and deploy the source for us

> Make sure to populate the service account password with JSON from sa fiile

```bash
kubectl apply -f src-to-url/kaniko.yaml
kubectl apply -f src-to-url/app.yaml
```

Add `- name: build-secret` to the bottom of


```shell
kubectl edit serviceaccount default
```

```shell
kubectl get services.serving.knative.dev src-to-url -o yaml
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
