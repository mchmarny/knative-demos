# Demo: Orchestrating source-to-URL workflows using Knative

This demo shows how to use Knative to go from source code in a git repository to a
running application with a URL. In this demo we will deploy a [simple app](https://github.com/mchmarny/simple-app)
to a Knative cluster.

## On-cluster Build

This sample leverages the `kaniko` build template to perform a source-to-container builds. For list of all the available build templates see the [build-templates](https://github.com/knative/build-templates) repo.

1. Install the `kaniko` template (one time)

```bash
kubectl -n demo apply -f https://raw.githubusercontent.com/knative/build-templates/master/kaniko/kaniko.yaml
```

2. Install the app:

```bash
kubectl apply -f app.yaml
```

3. Navigate to the `src-to-url` URL (http://src-to-url.demo.knative.tech/) to see the results.

## Cloud Build

Alternatively, you can leverage build service like Google's [Cloud Build](https://cloud.google.com/cloud-build/) to automate your build pipeline. For example of using Cloud Build to deploy your git-based source code to Knative see
[knative-gitops-using-cloud-build](https://github.com/mchmarny/knative-gitops-using-cloud-build).

## Cleanup

To remove the sample app from your cluster, delete the service record:

```bash
kubectl delete -f app.yaml
```
