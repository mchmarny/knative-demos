# Knative Events using Twitter, Cloud Firestore, Slack, and WebSockets Viewer

Simple pipeline combining Twitter search results and Knative Events to store, classify and display events

![alt text](image/overview.png "Overview")

## Setup

### Event Source

To configure the Twitter event source you will need Twitter API access keys. [Good instructions on how to get them](https://iag.me/socialmedia/how-to-create-a-twitter-app-in-8-easy-steps/)

Once you get the four keys, you will need to create Twitter API keys secret:

```shell
# kubectl delete secret ktweet-secrets -n demo
kubectl create secret generic ktweet-secrets -n demo \
    --from-literal=T_CONSUMER_KEY=$P_CONSUMER_KEY \
    --from-literal=T_CONSUMER_SECRET=$P_CONSUMER_SECRET \
    --from-literal=T_ACCESS_TOKEN=$P_ACCESS_TOKEN \
    --from-literal=T_ACCESS_SECRET=$P_ACCESS_SECRET
```

Additionally, you will need to define the search term for which you want the source to search Twitter (`--query=YourSearchTermHere`) in `config/source.yaml`. Once you are done editing, save the file and apply to your Knative cluster:


```shell
kubectl apply -f config/source.yaml -n demo
```

Should return

```shell
containersource.sources.eventing.knative.dev/twitter-source created
```

Verify that `twitter-source` source was created

```shell
kubectl get sources -n demo
```

Should return

```shell
NAME                                                          AGE
containersource.sources.eventing.knative.dev/twitter-source   33s
```

You can also right away see if the there are some tweets matching your search

```shell
kubectl logs -l eventing.knative.dev/source=twitter-source -n demo -c source
```

Should return

```shell
2019/07/11 13:23:14 Got tweet:     1149308143958134784
2019/07/11 13:23:14 Posting tweet: 1149308143958134784
2019/07/11 13:23:14 Got tweet:     1149308145359118336
2019/07/11 13:23:14 Posting tweet: 1149308145359118336
```

### Store Service (Step #1)

If you haven't done so already, you will need to enable Firestore in your GCP project, [create Cloud Firestore project](https://console.cloud.google.com/projectselector/apis/api/firestore.googleapis.com/overview), which will also enables your API in the Cloud API Manager.

The store service will persist tweets into collection defined in the `config/store.yaml` (`knative-tweets` by default). To deploy this service and corresponding trigger apply:


```shell
kubectl apply -f config/store.yaml -n demo
```

The response should be

```shell
service.serving.knative.dev/eventstore created
trigger.eventing.knative.dev/twitter-events-trigger created
```

To check if the service was deployed successfully you can check the status using `kubectl get pods -n demo` command. The response should look something like this (e.g. Ready `3/3` and Status `Running`).

```shell
NAME                                          READY    STATUS    RESTARTS   AGE
eventstore-qp2vz-deployment-7f458744dc-bltqz  2/2      Running   0          33s
```

The above command has also created a trigger. Two things to point here, were are using `type: com.twitter` filter to send to our `eventstore` service only the events of twitter type. We also define the target service here by its reference in the `subscriber` portion of trigger. You can verity that `twitter-events-trigger` trigger was created

```shell
kubectl get triggers -n demo
```

Should return

```shell
NAME                     READY   BROKER    SUBSCRIBER_URI                            AGE
twitter-events-trigger   True    default   http://eventstore.demo.svc.cluster.local  1m
```

## Quick Test

You should be able now see the Cloud Events being saved in your Firestore console under the `knative-tweets` collection (unless you changed the name during store service deployment)

You can also monitor the logs for `store-service`

```shell
kubectl logs -l serving.knative.dev/service=eventstore -n demo -c user-container
```

## Classification Service (Step #2)

Now that the tweets are being published by our source to the default broker, we can create the trigger and service that will classify these tweets. To deploy this service apply:

```shell
kubectl apply -f config/classifier.yaml -n demo
```

The response should be

```shell
service.serving.knative.dev/sentclass created
trigger.eventing.knative.dev/sentiment-classifier-trigger created
```

To check if the service was deployed successfully you can check the status using `kubectl get pods -n demo` command. The response should look something like this (e.g. Ready `3/3` and Status `Running`).

```shell
NAME                                          READY   STATUS    RESTARTS   AGE
sentclass-9ndr7-deployment-55cbd7cdcc-lt5gz   2/2     Running   0          18s
```

The above command also has crated classification service trigger. Just like in the event store service, were are using `type: com.twitter` filter to send to our `sentclass` service only the events of twitter type. We also define the target service here by its reference in the `subscriber` portion of trigger. To verity that `sentiment-classifier-trigger` trigger was created

```shell
kubectl get triggers -n demo
```

Should return

```shell
NAME                         READY   BROKER    SUBSCRIBER_URI                            AGE
sentiment-classifier-trigger  True    default   http://sentclass.demo.svc.cluster.local   43s
```

## Translation Service (Step #3)

In case when the tweets are in language not supported by the backing API, the Classification Service will fail and publish the offending tweet to the broker with `com.twitter.noneng` type. We will configure the translation trigger filter with that type so the offending tweets can be translated and re-publish back to the broker with the original type `com.twitter`. To deploy this service apply:

```shell
kubectl apply -f config/translation.yaml -n demo
```

The response should be

```shell
service.serving.knative.dev/tranlator created
trigger.eventing.knative.dev/translator-trigger created
```

To check if the service was deployed successfully you can check the status using `kubectl get pods -n demo` command. The response should look something like this (e.g. Ready `3/3` and Status `Running`).

```shell
NAME                                          READY   STATUS    RESTARTS   AGE
tranlator-qd9px-deployment-6dffb6b986-znz94   2/2     Running   0          21s
```

The above command also has crated translation service trigger. Just like in the event store service. To verity that `translator-trigger` trigger was created

```shell
kubectl get triggers -n demo
```

Should return

```shell
NAME                READY   BROKER    SUBSCRIBER_URI                            AGE
translator-trigger  True    default   http://tranlator.demo.svc.cluster.local   1m
```

## View Service (Step #5)

The classification service defined in step #2 will publish results to the default broker. The the negative tweets with type `com.twitter.negative` and positive with type `com.twitter.positive`. Let's create the viewing service now so we can see the positive tweets and come back to the negative tweets that will be published to slack later.

To do that let's deploy the viewer app and it's trigger by applying:

```shell
kubectl apply -f config/view.yaml -n demo
```

The response should be

```shell
service.serving.knative.dev/tweetviewer created
trigger.eventing.knative.dev/twitter-events-viewer created
```

To check if the service was deployed successfully you can check the status using `kubectl get pods -n demo` command. The response should look something like this (e.g. Ready `3/3` and Status `Running`).

```shell
NAME                    READY     STATUS    RESTARTS                                    AGE
twitter-events-viewer   True      default   http://tweetviewer.demo.svc.cluster.local   24s
```

Again, the above command created a service trigger. The only thing to point out here is that we are now filtering only the events that have been classified as positive (type: `com.twitter.positive`).

```yaml
filter:
  sourceAndType:
    type: com.twitter.positive
```

You can verity that `twitter-events-viewer` trigger was created

```shell
kubectl get triggers -n demo
```

Should return

```shell
NAME                    READY   BROKER    SUBSCRIBER_URI                               AGE
twitter-events-viewer   True    default   http://tweetviewer.demo.svc.cluster.local    17h
```

> Navigate to https://tweetviewer.demo.knative.tech/ now and leave the viewer open

## Slack Publish (Step #6)

The classification service defined in step #2 identifies also tweets that appear to be negative and posts them back to the default broker with the `com.twitter.negative` type. Let's create the Slack publish service now that will post these tweets to a Slack channel.

First, create a secret with the Slack token and channel details:

> Note, Slack channel is not the name of the channel but rather it's ID

```shell
kubectl create secret generic slack-notif-secrets -n demo \
  --from-literal=SLACK_CHANNEL=$SLACK_KN_TWEETS_CHANNEL \
  --from-literal=SLACK_TOKEN=$SLACK_KNTWEETS_API_TOKEN
```

Now, lets' install the Slack publishing service and corresponding trigger:


```shell
kubectl apply -f config/slack.yaml -n demo
```

The response should be

```shell
service.serving.knative.dev/slack-publisher created
trigger.eventing.knative.dev/slack-tweet-notifier created
```

To check if the service was deployed successfully you can check the status using `kubectl get pods -n demo` command. The response should look something like this (e.g. Ready `3/3` and Status `Running`).

```shell
NAME                                                 READY   STATUS    RESTARTS   AGE
slack-publisher-5rx2l-deployment-6d4fc5b5bd-cfwcr    2/2     Running   0          22s
```

Again, the only thing to point out here is that we are now filtering only the events that have been classified as positive (type: `com.twitter.negative`).

```yaml
filter:
  sourceAndType:
    type: com.twitter.negative
```

You can verity that `slack-tweet-notifier` trigger was created

```shell
kubectl get triggers -n demo
```

Should return

```shell
NAME                  READY   BROKER    SUBSCRIBER_URI                                   AGE
slack-tweet-notifier   True    default   http://slack-publisher.demo.svc.cluster.local    1m
```

## Demo

Ask audience to tweet about `knative` (doesn't have to be a `#knative` tag). Also ask for non-English tweets to show the translation service.

## Reset

Run this before each demo to set known state:

```shell
kubectl delete -f config/ -n demo --ignore-not-found=true
kubectl delete secret ktweet-secrets -n demo
kubectl delete secret slack-notif-secrets -n demo
```