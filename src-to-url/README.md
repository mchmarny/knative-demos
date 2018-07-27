# Demo: Orchestrating source-to-URL workflows on Kubernetes


This demo shows how to use Knative to go from source code in a git repository to a 
running application with a URL. In this demo we will deploy a [simple app](https://github.com/mchmarny/simple-app) 
to a Knative cluster. 

> Make sure to populate the service account password with JSON from the file.

This sample leverages the kaniko build template to perform a source-to-container build on the 
Kubernetes cluster.

1. Install the kaniko manifest and deploy the app:
   
   ```bash
   kubectl apply -f src-to-url/kaniko.yaml
   kubectl apply -f src-to-url/app.yaml
   ```

1. Add `- name: build-secret` to the bottom of the service account:

   ```shell
   kubectl edit serviceaccount default
   ```
   
1. To find the URL for your service, use:
   
   ```shell
   kubectl get services.serving.knative.dev src-to-url -o yaml
   ```

1. Wait for the created ingress to obtain a public IP:

   ```bash
   watch kubectl get pods
   ```

1. Navigate to the `src-to-url` URL (http://src-to-url.default.project-serverless.com/) to see the results.


## Cleanup

To remove the sample app from your cluster, delete the service record:

```bash
kubectl delete -f src-to-url/app.yaml
```
