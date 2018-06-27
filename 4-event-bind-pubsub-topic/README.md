# IoT Core Demo


## Create Subscription

IoT Core creates topics. If you have not done so already, you can create
GCP PubSub subscription for that topic using  `gcloud` by executing the
following command:

```shell
gcloud pubsub subscriptions create iot-demo-sub --topic=iot-demo
```

To pull on the topic for latest messages

```shell
gcloud alpha pubsub subscriptions pull iot-demo-sub --wait
```

## Create Device Certs

To connect device to IoT Core gateway you will have to create certificates

```shell
openssl genrsa -out rsa_private.pem 2048
openssl rsa -in rsa_private.pem -pubout -out rsa_public.pem
```

Once created, add the public key to the IoT Core registry.

## Generate Data

To mimic IoT device sending data to the IoT gateway just run the provide
Node.js client with following parameters


```shell
node device.js \
    --projectId=s9-demo \
    --cloudRegion=us-central1 \
    --registryId=next18-demo \
    --deviceId=next18-demo-client \
    --privateKeyFile=./rsa_private.pem \
    --algorithm=RS256
```