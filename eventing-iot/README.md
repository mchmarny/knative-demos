# IoT Event Processing using Knative and IoT core

This demo shows how to bind a running Knative service to an
[IoT core](https://cloud.google.com/iot-core/) using
[GCP PubSub](https://cloud.google.com/pubsub/) as the event source. With minor
modifications, it can be used to bind a running service to anything that sends
events via GCP PubSub.

> All commands are given relative to the root of this repository

## Setup

To make the following commands easier, we are going to set the various variables
here and use them later.

### Variables you must Change

```shell
export IOTCORE_PROJECT="s9-demo"
```

### Variables you may Change

```shell
export CHANNEL_NAME="iot-demo"
export IOTCORE_REGISTRY="iot-demo"
export IOTCORE_DEVICE="iot-demo-client"
export IOTCORE_REGION="us-central1"
export IOTCORE_TOPIC_DATA="iot-demo-pubsub-topic"
export IOTCORE_TOPIC_DEVICE="iot-demo-device-pubsub-topic"
```

### Prerequisites

* Setup [Knative Serving](https://github.com/knative/docs/blob/master/install)
  * Configure [outbound network access](https://github.com/knative/docs/blob/master/serving/outbound-network-access.md)
  * Setup [Knative Eventing](https://github.com/knative/docs/tree/master/eventing) using the `release.yaml` file. This example does not require GCP.


### Configuration

* Enable the 'Cloud Pub/Sub API' on that project.

```shell
gcloud services enable pubsub.googleapis.com
```

* Create the two GCP PubSub `topic`s.

```shell
gcloud pubsub topics create $IOTCORE_TOPIC_DATA
gcloud pubsub topics create $IOTCORE_TOPIC_DEVICE
```


#### GCP PubSub Source

1.  Create a GCP
    [Service Account](https://console.cloud.google.com/iam-admin/serviceaccounts/project).

    1.  Determine the Service Account to use, or create a new one.
    2.  Give that Service Account the 'Pub/Sub Editor' role on your GCP project.
    3.  Download a new JSON private key for that Service Account.
    4.  Create two secrets with the downloaded key (one for the Source, one for
        the Receive Adapter):

```shell
kubectl -n knative-sources create secret generic gcppubsub-source-key --from-file=key.json=PATH_TO_KEY_FILE.json
kubectl -n demo create secret generic google-cloud-key --from-file=key.json=PATH_TO_KEY_FILE.json
```

2.  Deploy the `GcpPubSubSource` controller as part of eventing-source's
    controller.

> Note: update project ID before applying `source.yaml`

```shall
kubectl -n demo apply -f source.yaml
```

### Deploying

Create a `Channel`.

> Note, if you changed the names of env vars above, you will need to update the `channel.yaml` file

```shall
kubectl -n demo apply -f channel.yaml
```

Deploy `GcpPubSubSource`

> Note, update project ID, topic, and channel name before applying `source.yaml`

```shell
kubectl apply -f source.yaml
```

Even though the `Source` isn't completely ready yet, we can setup the
`Subscription` for all events coming out of it.

Deploy `Subscription`.

> Note, update channel name before applying `source.yaml`

```shell
kubectl apply -f subscription.yaml
```

#### IoT Core

We now have everything setup on the Knative side. We will now setup the IoT
Core.

Create a device registry:

```shell
gcloud iot registries create $IOTCORE_REGISTRY \
    --project=$IOTCORE_PROJECT \
    --region=$IOTCORE_REGION \
    --event-notification-config=topic=$IOTCORE_TOPIC_DATA \
    --state-pubsub-topic=$IOTCORE_TOPIC_DEVICE
```

Create the certificates.

  ```shell
  openssl req -x509 -nodes -newkey rsa:2048 \
      -keyout device.key.pem \
      -out device.crt.pem \
      -days 365 \
      -subj "/CN=unused"
  curl https://pki.google.com/roots.pem > ./root-ca.pem
  ```

Register a device using the generated certificates.

```shell
gcloud iot devices create $IOTCORE_DEVICE \
  --project=$IOTCORE_PROJECT \
  --region=$IOTCORE_REGION \
  --registry=$IOTCORE_REGISTRY \
  --public-key path=./device.crt.pem,type=rsa-x509-pem
```

### Demo

We now have everything installed and ready to go. We will generate events and
see them in the subscriber.

In separate terminal, uUse [`kail`](https://github.com/boz/kail) to tail on the `message-dumper` logs of the subscriber.

```shell
kail -d iot-message-dumper-00001-deployment -c user-container
```

Now in the terminal where you we defined all those env vars, run the following program to generate events.

```shell
go run ./generator.go \
  -project $IOTCORE_PROJECT \
  -region $IOTCORE_REGION \
  -registry $IOTCORE_REGISTRY \
  -device $IOTCORE_DEVICE \
  -ca ./root-ca.pem \
  -key ./device.key.pem \
  -src "iot-core demo" \
  -events 10
```
