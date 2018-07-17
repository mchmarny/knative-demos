# Event Binding to IoT Core (PubSub)

> Hard-coding a few example variables here for ease of demo

## Setup

Define a few environment variables

```shell
export IOTCORE_PROJECT="s9-demo"
export IOTCORE_REG="next18-demo"
export IOTCORE_DEVICE="next18-demo-client"
export IOTCORE_REGION="us-central1"
export IOTCORE_TOPIC_DATA="iot-demo"
export IOTCORE_TOPIC_DEVICE="iot-demo-device"
```

## Creating a device registry

```shell
gcloud iot registries create $IOTCORE_REG \
    --project=$IOTCORE_PROJECT \
    --region=$IOTCORE_REGION \
    --event-notification-config=$IOTCORE_TOPIC_DATA \
    --state-pubsub-topic=$IOTCORE_TOPIC_DEVICE
```

## Create Device Certs

To connect device to IoT Core gateway you will have to create certificates

```shell
openssl genrsa -out rsa_private.pem 2048
openssl rsa -in rsa_private.pem -pubout -out rsa_public.pem
```

Once created, add the public key to the IoT Core registry.

## Creating IoT Device Registration

```shell
gcloud iot devices create $IOTCORE_DEVICE \
  --project=$IOTCORE_PROJECT \
  --region=$IOTCORE_REGION \
  --registry=$IOTCORE_REG \
  --public-key path=./rsa_public.pem,type=rs256
```

## Generate Data

To mimic IoT device sending data to the IoT gateway just run the provide
Node.js client with following parameters


```shell
node send-data.js \
    --projectId=$IOTCORE_PROJECT \
    --cloudRegion=$IOTCORE_REGION \
    --registryId=$IOTCORE_REG \
    --deviceId=$IOTCORE_DEVICE \
    --privateKeyFile=./iot_demo_private.pem \
    --algorithm=RS256
```

The above "device" will publish event per second to the IoT Core gateway.
The gateway will automatically publish the received events to the configured
PubSub topic (`iot-demo`).

The payload sent by this mocked IoT Client looks like this

```shell
{
  source_id: 'next18-demo-client',
  event_id: '41e13421-25aa-4e93-bca8-0ffeb5c040c8',
  event_ts: 1531515192370,
  metric: 9
}
```

Where `event_id` is a unique UUIDv4 ID, `event_ts` is Epoch time, and `metric` is a random number 1-10.

## Create Function That Handles Events

Now we want to consume our IoT events and handle them in our function code.
Let's create the function for it.

```shell
kubectl apply -f event-flow/route.yaml
kubectl apply -f event-flow/configuration.yaml
```

## Create Event Source

Before we can Bind an Action to an Event Source, we have to create the Event Source
that knows how to wire events into actions for that particular Event Type.
First let's create a ServiceAccount so that we can run the local receive adapter
(in Pull mode) to poll for events from this topic. Then let's create a GCP PubSub
as an event source that we can bind to.

```shell
kubectl apply -f event-flow/serviceaccount.yaml
kubectl apply -f event-flow/serviceaccountbinding.yaml
kubectl apply -f event-flow/eventsource.yaml
kubectl apply -f event-flow/eventtype.yaml
```

## Bind IoT Events to our function

We have created a Function that we want to consume our IoT events, and we have an event
source that's emitting events via GCP PubSub, let's wire the two together.

```shell
kubectl apply -f event-flow/flow.yaml
```

