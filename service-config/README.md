# Service Configuration Demo

This demo illustrates some of the available service configuration options

## Deploy

```shell
kubectl apply -f service.yaml
```

After deployment, the `config` application will expose the following endpoints:

* `/` Landing page with links to this endpoints
* `/kn` Knative-specific data as defined in the [Runtime Contract](https://github.com/knative/serving/blob/master/docs/runtime-contract.md)
* `/req` Request context with environment variables and headers
* `/res` Serving node info (Hostname, OS, Boot-time) and Pod available Memory/CPU resources
* `/log` Content of specific log or log list in dir (e.g. /log?logpath=/var/log/app.log)


## Demo

https://config.demo.knative.tech/

## Endpoint How-to

The JSON outputting endpoints (`/kn`, `/req`, `/res`) include request metadata object. This provides context for each response and is useful when persisting returned data for evaluation/texting.

```json
{
    "meta": {
        "id": "215bb44e-0513-44a5-a640-fc1546daf294",
        "ts": "2019-01-04T20:09:12.52097224Z",
        "uri": "/req",
        "host": "config.demo.knative.tech",
        "method": "GET"
    },
    ...
```

### `req` - HTTP Request

The `/req` endpoint provides an easy way to eval expected environment variables or headers for your requests. For example to get a release version of the `config` app you would execute:

```shell
curl -s https://config.demo.knative.tech/req |  jq '.envs.RELEASE'
```

Or to get your `user-agent` as seen by the Knative service

```shell
curl -s https://config.demo.knative.tech/req |  jq '.head."user-agent"'
```

### `/node` (Serving Node)

The `/node` endpoint provides information about the node which is serving your request. For example to see the boot time of that node and its hostname

```shell
curl -s https://config.demo.knative.tech/res |  jq '.node.bootTs,.meta.host'
```

### `/kn` (Knative)

The `/kn` endpoint is what you would use to evaluate [Knative-specific data](https://github.com/knative/serving/blob/master/docs/runtime-contract.md). In addition to the Knative environment variables (`PORT` and ones prefixed by `K_` like `K_CONFIGURATION`, `K_REVISION`, and `K_SERVICE`), the `/kn` endpoint also exposes information about the recommended file system mounts (e.g. `/tmp`, `/var/log`, or `/dev/log`).

To test for example if the `/etc/hosts` has the required `R/W` permissions you can run this query. It searches for `comment` in the returned document where `access` group `name == "DNS"` and and the item within that group has the `path == /etc/hosts`

```shell
curl -s https://config.demo.knative.tech/kn \
  | jq -r --arg group "DNS" \
    '.access[] | if .group == $group then . else empty end' \
    | jq -r --arg path "/etc/hosts" \
      '.list[] | if .path == $path then .comment else empty end'
```

### `/log`

The `/log` endpoint returns the log file specified by the `logpath` parameter in query string. ((e.g. [/log?logpath=/var/log/config.log](https://config.demo.knative.tech/log?logpath=/var/log/config.log))). If the `logpath` parameter is a directly the `/log` will return a list of content in that directory.

> Note, `config` by default writes logs to `stdout` unless the `LOG_TO_FILE` environment variable is set (anything other than "" will do). If that variable is set, `ktest` will output its own logs to `/var/log/config.log`

> Note, currently the `/log` endpoint will not return any logs larger than `1MB`.

To search log you can pipe the `/log` output through `greb`. For example to find out the `port` on which the server started

```shell
curl -s https://config.demo.knative.tech/log?logpath=/var/log/config.log \
  | grep 'Server starting on port'
```

