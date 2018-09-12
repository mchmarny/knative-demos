# Demo: Jib-based Build Pipeline


This demo shows how to use Knative to build java code from source code in a git repository to a
running application. In this demo we will build a sample [Spring app using Google Cloud Vision API](https://github.com/mchmarny/spring-cloud-gcp/tree/master/spring-cloud-gcp-samples/spring-cloud-gcp-vision-api-sample)
and deploy it to a Knative cluster.

1. Install the Jib template on Kantive cluster (one time task):

The Jib template builds Java/Kotlin/Groovy/Scala source into a container image using Google's Jib tool.

```bash
kubectl apply -f https://raw.githubusercontent.com/knative/build-templates/master/jib/jib-maven.yaml
```

2. Deploy your app:


```shell
kubectl apply -f jib-build/app.yaml
```

3. Wait for the build to complete:

> First time you build, Maven will have to download all the dependencies (~3 min). After that, things get a lot faster. Subsequent builds as fast as ~15 sec.

```bash
kubectl get pods
```

If you are interested in watching the on-cluster build, you can watch the `build-step-build-and-push` logs

```shell
kubectl logs POD_NAME -c build-step-build-and-push -f
```

1. Run the deployed app

Navigate to the `vision` URL (https://vision.default.project-serverless.com/) to see the results.

## Cleanup

To remove the sample app from your cluster, delete the service record:

```bash
kubectl delete -f jib-build/app.yaml
```
