# Demo: Knative Client (kn)

In this simple demo we will use Knative Client CLI called `kn` to deploy a pre-built docker image. The source code for the image used in this demo is located in the [github.com/mchmarny/maxprime](https://github.com/mchmarny/maxprime) repo. The image itself is public ([gcr.io/cloudylabs-public/maxprime](https://gcr.io/cloudylabs-public/maxprime))

## Deploy Service

```shell
kn service create my-service \
    --image gcr.io/cloudylabs-public/maxprime \
    --namespace demo
```

> Note, the above command creates service in the `demo` namespace. You can remove this flag to deploy to `default` namespace or specify your own.

The domain will be different but when done, the `kn` utility will return:

```shell
Service 'my-service' successfully created in namespace 'demo'.
Waiting for service 'my-service' to become ready ... OK

Service URL:
http://my-service.demo.knative.tech
```

## Cleanup

To remove the `my-service` app from your cluster

```shell
    kn service delete my-service --namespace demo
```
