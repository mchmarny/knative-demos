# Show objects created by Knative

Let's list the objects that Knative created in Kubernetes

## Configuration

* Desired current state of deployment (#HEAD)
* Records both code and configuration (separated, ala 12 factor)
* Stamps out builds / revisions as it is updated


```shell
kubectl get configurations -o yaml
```

## Revision

* Code and configuration snapshot
* k8s infra: Deployment, ReplicaSet, Pods, etc

```shell
kubectl get revisions -o yaml
```

## Route

* Traffic assignment to Revisions (fractional scaling or by name)
* Built using Istio


```shell
kubectl get routes -o yaml
```

