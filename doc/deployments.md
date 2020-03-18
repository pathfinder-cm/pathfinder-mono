# Deployments

Deployment is an entity that manages containers.

Containers managed by deployment are containers that have a name in this pattern: **deployment name-dash-number,** for example:
- Deployment **hitsu-kafka** will manages container **hitsu-kafka-01**, **hitsu-kafka-02**, and so on.
- If replica count is 3, there should be **hitsu-kafka-01**, **hitsu-kafka-02**, and **hitsu-kafka-03**.
- If replica count is 3, containers named **hitsu-kafka-04** or **hitsu-kafka-99** will be deleted by the deployment scheduler.

## Creating Deployment

Deployment can be created from the UI. The definition itself must contains things needed to create a container.

This will be an example of deployment definitions:

```
{
  "source": {
    "mode": "pull",
    "alias": "lxd-ubuntu-minimal-consul-1.1.0-8",
    "remote": {
      "name": "barito-registry"
    },
    "fingerprint": "",
    "source_type": "image"
  },
  "resource": {
    "cpu_limit": "0-2",
    "mem_limit": "500MB"
  },
  "strategy": "RollingUpdate",
  "healthcheck": {
    "port": 9500,
    "type": "tcp",
    "payload": "",
    "timeout": "",
    "endpoint": ""
  },
  "allow_failure": "false",
  "bootstrappers": [
    {
      "bootstrap_type": "chef-solo",
      "bootstrap_attributes": {
        "consul": {
          "hosts": "$pf-meta:deployment_ip_addresses?deployment_name=fadli-consul"
        },
        "run_list": [

        ]
      },
      "bootstrap_cookbooks_url": "https://github.com/BaritoLog/chef-repo/archive/master.tar.gz"
    }
  ],
  "container_type": "stateless"
}
```

It will create containers based on its desired replica count. Minimum available replicas can be set so Pathfinder will keep these amount of available containers while rebootstrapping other containers.

## Pathfinder Deployment Script

As you can see, there is a small script started with `$pf-meta:`. Those scripts will be executed before putting them to container attributes.

The format of it is like this:
```
$pf-meta:function-name?key-1=value-1&key-n&value-n
```

### `deployment_ip_addresses`

Get IP addresses of containers managed by specified `deployment_name`.

Example:
```
$pf-meta:deployment_ip_addresses?deployment_name=fadli-consul
```

It may be rendered to:
```
["192.168.0.1", "192.168.0.2"]
```

### `container_id`

Get current container ID.

Example:
```
$pf-meta?container_id
```

If current container name is `hitsu-consul-02` (2nd replica), it may render to:
```
2
```

### `deployment_host_sequences`

Get a sequence array of specified `host` with ID as prefix. Current container will be changed to `self_host` which defaults to `0.0.0.0`.

Example:
```
$pf-meta:deployment_host_sequences?host=zookeeper.service.consul
```

If it's being run on 2nd replica, it may render to:
```
["1.zookeeper.service.consul", "0.0.0.0", "3.zookeeper.service.consul"]
```
