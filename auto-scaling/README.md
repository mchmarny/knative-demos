# Demo: Automatic scaling and sizing workloads with Knative

This demo shows the autos-caling capabilities of Knative with the original `simple-app`
that we deployed in the [Deploying an image](../image-deploy/README.md) demo.

> Assuming you already configured static IP and custom domain. In this demo we will use `project-serverless.com`

## Setup

To make auto-scaling easier to demo, you may wanna tweak the `config-autoscaler` config map:

```yaml
  scale-to-zero-grace-period: 30s
  scale-to-zero-threshold: 1m
```

* `scale-to-zero-threshold` - total time between traffic drops and when the resources are deprovisioned [default: 5m]
* `scale-to-zero-grace-period` - length of time an inactive revision is left running before it is scaled to zero [default: 2m]

You can edit these values directly using `kubectl`:

```shell
kubectl edit cm config-autoscaler -n knative-serving
```

## n to 0 pods

First, let's check on the app that we deployed:

```shell
watch kubectl get pods
```

As you can see from the output, the `simple-app` pod is not there. This is because it has scaled down
due to no requests.

## 0 to 1 pods

Now, let's bring this app back up by simulating a user and accessing its URL in a browser:

http://simple.default.project-serverless.com/

Now, check the pods again:

```shell
watch kubectl get pods
```

Now we can see that the `simple-*` pod appeared on the list and is ready to serve traffic.

## 1 to n pods

Let's use a synthetic load generator to quickly increase the number of Queries Per Second (QPS)
to demonstrate how Knative scales its workloads.

We are going to use our script to spin up 4 threads that are running more than 1K QPS each to see
how Knative scales the underlining pod:

```shell
auto-scaling/stress-test.sh
```
Now, check the pods again:

```shell
watch kubectl get pods
```
There should be more pods running to meet the traffic demands.
