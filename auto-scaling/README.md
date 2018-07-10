# Demo Knative autoscaling

 I this demo we will use our origianl `Primer` demo and a synthetic load generator to quickly increase the number of Queries Per Second (QPS).

 In one console window we will watch the pods

 ```shell
 watch kubectl get pods
 ```

 In another, fire off 4 concurrent threads with 1K requests each

```shell
 auto-scaling/stress-test.sh \
    -a http://primer.default.project-serverless.com/50 -c 4 -r 1000
 ```
