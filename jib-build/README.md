# Demo: Jib-based Tekton Pipeline

This demo shows how to use Knative Pipelines to build java code from source code in a git repository to a
running application. In this demo we will build a sample [Spring app using Google Cloud Vision API](https://github.com/mchmarny/spring-cloud-gcp/tree/master/spring-cloud-gcp-samples/spring-cloud-gcp-vision-api-sample)
and deploy it to a Knative cluster.

### Configure Dependance Cache

Maven will be downloading a lot of dependencies, to ensure the subsequent build run faster, define a `PersistentVolumeClaim` on your cluster

```bash
kubectl apply -f cache.yaml
```

### Install the Tekton Task on Knative cluster (one time task):

The Tekton Task for Maven builds Java/Kotlin/Groovy/Scala source into a container image using Google's Jib tool.

```bash
kubectl apply -f task-jdk-8.yaml
```

### Install Secret (one time task):

First you need to create a GCP service account with sufficient rights to push images to GCR. Then edit the provided `secret.yaml` file and paste the secret into the `password` field.

Tekton will use this account to authenticate to the registry

```shell
kubectl apply -f secret.yaml
```

### Deploy Build:

With Tokton configured on your Knative cluster, you can now build Java apps.

> Make sure to edit the `PipelineResource` component to change `cloudylabs` to your own project name

```yaml
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: vision-image-build
spec:
  type: image
  params:
    - name: url
      value: gcr.io/cloudylabs/vision:3.2.10
```

To submit your build now, run:


```shell
kubectl apply -f maven-build.yaml
```


### Wait for the build to complete:

> First time you build, Maven will have to download all the dependencies (~3 min). After that, things get a lot faster. Subsequent builds as fast as ~15 sec.

```bash
kubectl get pods
```

If you are interested in watching the on-cluster build, you can watch the `build-step-build-and-push` logs

```shell
kubectl logs jib-maven-vision-image-build-pod-**** -c step-build-and-push -f
```

> Replace pod name in the above command with the unique name on your cluster with the name listed by `kubectl get pods`

The resulting output should look like something like this

```shell
[INFO] Built and pushed image as gcr.io/cloudylabs/vision:3.2.10
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 33.250 s
[INFO] Finished at: 2019-09-14T13:34:29Z
[INFO] Final Memory: 58M/537M
[INFO] ------------------------------------------------------------------------
```

### Deploy Vision app

With the image built, you can now deploy

> Make sure to replace `cloudylabs` with the name of your project

```shell
container:
    image: gcr.io/cloudylabs/vision:3.2.10
```

Now apply the updated manifest

```shell
kubectl apply -f service.yaml
```


### View

Navigate to the `vision` URL (https://vision.demo.knative.tech/) to see the results.

## Cleanup

To remove the sample app from your cluster, delete the service record:

```bash
kubectl delete -f service.yaml
```
