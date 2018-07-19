# Deploying an image with Knative service

In this demo we will deploy a pre-built docker image of a [simple-app](https://github.com/mchmarny/simple-app) to a Knative cluster.

1. Apply the configuration: 
   
   ```bash
   kubectl apply -f image-deploy/app.yaml
   ```

1. Wait for the created ingress to obtain a public IP:

   ```bash
   watch kubectl get pods
   ```

1. Navigate to http://simple.default.project-serverless.com/ to see the results.

## Cleanup

To remove the sample app from your cluster, delete the `.yaml` file:

```bash
kubectl delete -f image-deploy/app.yaml
```
