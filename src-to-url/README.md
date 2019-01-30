# Demo: Orchestrating source-to-URL workflows on Kubernetes


This demo shows how to use Knative to go from source code in a git repository to a
running application with a URL. In this demo we will deploy a [simple app](https://github.com/mchmarny/simple-app)
to a Knative cluster.

> Make sure to populate the service account password with JSON from the file.

This sample leverages the kaniko build template to perform a source-to-container build on the
Kubernetes cluster.

1. Install the kaniko manifest:

   ```bash
   kubectl -n demo apply -f https://raw.githubusercontent.com/knative/build-templates/master/kaniko/kaniko.yaml
   ```

2. Install the app:

   ```bash
   kubectl apply -f src-to-url/app.yaml
   ```


3. To find the URL for your service, use:

   ```shell
   kubectl get services.serving.knative.dev src-to-url -o yaml
   ```

4. Wait for the created ingress to obtain a public IP:

   ```bash
   watch kubectl get pods
   ```

5. Navigate to the `src-to-url` URL (http://src-to-url.demo.project-serverless.com/) to see the results.


## Cleanup

To remove the sample app from your cluster, delete the service record:

```bash
kubectl delete -f src-to-url/app.yaml
```
