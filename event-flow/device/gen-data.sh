#!/bin/bash

export IOTCORE_PROJECT="s9-demo"
export IOTCORE_REG="next18-demo"
export IOTCORE_DEVICE="next18-demo-client"
export IOTCORE_REGION="us-central1"
export IOTCORE_TOPIC_DATA="iot-demo"
export IOTCORE_TOPIC_DEVICE="iot-demo-device"

node send-data.js --projectId=$IOTCORE_PROJECT \
                  --cloudRegion=$IOTCORE_REGION \
                  --registryId=$IOTCORE_REG \
                  --deviceId=$IOTCORE_DEVICE \
                  --privateKeyFile=./iot_demo_private.pem \
                  --algorithm=RS256