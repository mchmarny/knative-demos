# Advanced deploy (aka blue/green)

Your map to help you navigate the Knative routes. Simple blue/green-like app deployment pattern demo.

## Deploy app (blue)

`kubectl apply -f 3-advanced-deploy-blue-green/stage1.yaml`

Check for external IP being assigned in k8s ingress service

`kubectl get ing`

When route created and IP assigned, navigate to http://route-demo.default.project-serverless.com to show deployed app. Let's call this blue (aka v1) version of the app.

## Deploy new (green) version of the app

`kubectl apply -f 3-advanced-deploy-blue-green/stage2.yaml`

This will only stage v2. That means:

* Won't route any of v1 (blue) traffic to that new (green) version, and
* Create new named route (`v2`) for testing of new the newlly deployed version

Refresh v1 (http://route-demo.default.project-serverless.com) to show our v2 takes no traffic,
and navigate to http://v2.route-demo.default.project-serverless.com to show the new `v2` named route.

## Migrate portion of v1 (blew) traffic to v2 (green)

`kubectl apply -f 3-advanced-deploy-blue-green/stage3.yaml`

Refresh (a few times) the original route http://route-demo.default.project-serverless.com to show part of traffic going to v2

> Note, demo uses 50/50 split to assure you don't have to refresh too much, normally you would start with 1-2% maybe

## Re-route 100% of traffic to v2 (green)

`kubectl apply -f 3-advanced-deploy-blue-green/stage4.yaml`

This will complete the deployment by sending all traffic to the new (green) version.

Refresh original route http://route-demo.default.project-serverless.com bunch of times to show that all traffic goes to v2 (green) and v1 (blue) no longer takes traffic.

Optionally, I like to pointing out that:

* I kept v1 (blue) entry with 0% traffic for speed of reverting, if ever necessary
* I added named route `v1` to the old (blue) version of the app to allow access for comp reasons

Navigate to http://v1.route-demo.default.project-serverless.com to show the old version accessible by `v1` named route


## Cleanup

```
kubectl delete -f 3-advanced-deploy-blue-green/stage4.yaml --ignore-not-found=true
kubectl delete -f 3-advanced-deploy-blue-green/stage3.yaml --ignore-not-found=true
kubectl delete -f 3-advanced-deploy-blue-green/stage2.yaml --ignore-not-found=true
kubectl delete -f 3-advanced-deploy-blue-green/stage1.yaml --ignore-not-found=true
```
