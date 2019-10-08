# Demo: Deploying existing image to Knative

In this demo we will deploy a pre-built docker image of a [maxprime](https://github.com/mchmarny/maxprime) to a Knative cluster.

> Assuming you already configured static IP and custom domain. In this demo we will use `knative.tech`

Knative `service` manifest (see [./app.yaml]) defines the deployment

```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: simple
spec:
  template:
    spec:
      containers:
        - image: gcr.io/cloudylabs-public/maxprime:0.2.1
          env:
            - name: RELEASE
              value: "v0.2.1-simple"
```

To deploy, simply apply that manifest to your cluster

```shell
kubectl apply -f app.yaml
```

The deployed app should be available under the same URL (https://simple.demo.knative.tech/)


## Cleanup

To remove the sample app from your cluster

```shell
kubectl delete -f app.yaml
```
