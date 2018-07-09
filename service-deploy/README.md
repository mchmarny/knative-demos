# Simple image deploy using Service

In this demo we will deploy a pre-built sample docker image of an app called `Primer` to Knative cluster.


```bash
kubectl apply -f kubectl get ing/app.yaml
```

Wait for the created ingress to obtain a public IP...

```bash
kubectl get ing --watch
```

> If you have pointed your DNS to the public IP of Knative you aer done, otherwise, continue reading...

Capture the IP and host name in environment variables by running these commands:

```bash
export SERVICE_IP=$(kubectl get ing primer-ingress \
  -o jsonpath="{.status.loadBalancer.ingress[0]['ip']}")

export SERVICE_HOST=$(kubectl get ing primer-ingress \
  -o jsonpath="{.spec.rules[0]['host']}")
```

> Alternatively, you can create an entry in your DNS server to point your sub-domain to the IP.

Run the Primer app:

```bash
curl -H "Host: ${SERVICE_HOST}" http://$SERVICE_IP/5000000
```

The higher the number, the longer it will run.

## Cleanup


```bash
kubectl delete -f 1-easy-deploy-using-service/app.yaml
```
