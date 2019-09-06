# Demo: Knative Client (kn)

In this simple demo we will use Knative Client CLI called `kn` to deploy a pre-built docker image. The source code for the image used in this demo is located in the [github.com/mchmarny/maxprime](https://github.com/mchmarny/maxprime) repo.

## Deploy Service

```shell
kn service create maxprime \
    --image gcr.io/knative-samples/maxprime \
    --namespace demo
```

> Note, the above command creates service in the `demo` namespace. You can remove this flag to deploy to `default` namespace or specify your own.

The domain will be different but when done, the `kn` utility will return:

```shell
Service 'maxprime' successfully created in namespace 'demo'.
Waiting for service 'maxprime' to become ready ... OK

Service URL:
http://maxprime.demo.knative.tech
```

## Cleanup

To remove the `maxprime` app from your cluster

```shell
    kn service delete maxprime --namespace demo
```
