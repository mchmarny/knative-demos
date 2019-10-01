# Knative Up

Series of scripts to make deploying Knative simpler

## Setup

Edit the [config](./config) file. The configuration values are documented (WIP). Once you update that file you should not have to edit any other scripts

## Cluster

Setup a new GKE cluster

```shell
./cluster-up
```

> To provision cluster with the Cloud Run add-on use the `./cloud-run-cluster-up` script

## Install

### Serving

Install the Knative serving components

```shell
./install-serving
```

### Eventing

Install the Knative serving components

```shell
./install-eventing
```

## Config

### Outbound Network

This captures your cluster IPv4 scope and tells Istio to ignore all outbound traffic except within that scope

```shell
./config-network
```

### Static IP

This will list reserved IPs in your project and prompt you to use one of those or create a new one. That IP will then be used to path `istio-ingressgateway` to ensure static IP is used in your cluster

```shell
./config-ip
```

### Custom Domain

This will use the domain you defined in the [config](./config) file to update the `config-domain` config map and list series of DNS entries you should make

```shell
./config-domain
```

### TLS Certificates

This will use the TLS certificates you defined in [config](./config) file to create the necessary TLS secrets and update the [Istio ingress gateway](./gateway.yaml)

```shell
./config-tls
```

## GPU Node Pool (optional)

If you plan on deploying services that require GPU, this will create the pool for you and apply the necessary drivers to make it available to your cluster

> Note, this script provides 1 node with 1 GPU, if you need more edit the number in the script itself

```shell
./pool-gpu
```

## Test

To test your deployment I've provided a simple demo app. In this demo we will deploy a pre-built docker image of a [maxprime](https://github.com/mchmarny/maxprime) to the demo name space in your new cluster


```shell
kubectl apply -f app.yaml
```

## Disclaimer

This is my personal project and it does not represent my employer. I take no responsibility for issues caused by this code. I do my best to ensure that everything works, but if something goes wrong, my apologies is all you will get.

## License
This software is released under the [Apache v2 License](../LICENSE)