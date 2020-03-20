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

## Internal Mechanism

### How deployment works?

The deployment rules specified in the top of this document will be enforced by the deployment scheduler. The deployment scheduler processing will be run first, then the container scheduler processing, so any changes to the container can be applied at the same processing period.

To achieve the goal of the deployment: easy scale up or scale down, the deployment scheduler itself is run like this for each deployment:
- Get intended/**wanted containers** based on deployment name and replica count, e.g.: deployment name is **dery**, replica count is 2, so wanted containers are **dery-01** and **dery-02**.
- Get **real containers** managed by this deployment based on deployment name only, e.g.: we have **dery-01** container only in Pathfinder.
- Create containers available in **wanted containers** but not available in **real containers**.
- Delete containers available in **real containers** but not available in **wanted containers**.
- For containers that available in **wanted containers** and **real containers**, render deployment definition (template of a container) to container attributes and re-bootstrap if the new attributes are different from the current container attributes.

### How rolling update works?

We did it by limiting delete and re-bootstrap operations for **bootstrapped** containers only.

If the minimum available replica is 2 and we have 3 **bootstrapped** containers, then we can only do single operation of delete or re-bootstrap for **bootstrapped** containers. The operations which aren't allowed will be eventually performed as the container finishes bootstrapping and becomes available.

### How we handle containers which need IP addresses of Consul containers?

We implemented the Pathfinder script. In the update operation of the deployment scheduler, **deployment definition** (template of a container) is being rendered to be **new container attributes** and containers will be re-bootstrapped if the **new attributes** are different from the **current container attributes.**

We add more processing in the specified rendering process by processing the JSON string started with `$pf-meta:`. An example scenario for this will be:
- A **kibana** deployment + script: `$pf-meta:deployment_ip_addresses?deployment_name=hitsu-consul` as bootstrap attributes in the deployment definition field.
- The Consul containers aren't being created, so the script renders to an empty array and the **kibana** container is being bootstrapped.
- The Consul containers are being created.
- The script renders to a different thing: an array of Consul IP addresses, but the **kibana** container can't be changed since it's still being bootstrapped.
- After the bootstrap process of the **kibana** container, it'll be bootstrapped again to synchronize with the new bootstrap attributes which have complete Consul IP addresses.

By using this method, eventually, every container will be bootstrapped using the correct attributes.

We leverages the usage of this Pathfinder script for other things, like:
- Zookeeper which needs **my_id** information,
- **zookeeper_hosts** which'll be configured, e.g.: `["0.0.0.0", "2.zookeeper.service.consul", "3.zookeeper.service.consul"]`.
