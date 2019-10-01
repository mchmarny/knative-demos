# Knative Up

Series of scripts to make deploying Knative simpler

> I'm toying with the idea of wrapping this into a simple CLI that would walk you through the entire process. Let me know if this sounds interesting and what areas the individual scripts below do not cover.

## Setup

Edit the [config](./config) file. The configuration values are documented (WIP). Once you update that file you should not have to edit any other scripts

## GKE

Setup a new GKE cluster

```shell
./cluster-up
```

> To provision cluster with the Cloud Run add-on use the `./cloud-run-cluster-up` script

### GPU Node Pool (optional)

If you plan on deploying services that require GPU, this will create a node pool for you with GPUs and apply the necessary drivers to make that pool available to your cluster

> Note, this script by default creates 1 node with 1 GPU. If you need more edit the number in the script itself

```shell
./pool-gpu
```

## Knative

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

## Knative Config

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

## Test

To test your deployment I've provided a simple test script. This script will deploy a demo app using a pre-built docker image ([maxprime](https://github.com/mchmarny/maxprime)) to the demo name space in your new cluster then run a pods health check and service readiness status check before finally navigating to the app itself in your default browser.


```shell
./test
```

## Disclaimer

This is my personal project and it does not represent my employer. I take no responsibility for issues caused by this code. I do my best to ensure that everything works, but if something goes wrong, my apologies is all you will get.

## License
This software is released under the [Apache v2 License](../LICENSE)