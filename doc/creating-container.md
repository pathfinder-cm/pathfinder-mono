# Creating Container

If you have external apps that want to create containers via pathfinder, then you can use pathfinder API to do that. But first, make sure that you have the necessary token to call the API. We can get the token by registering our external apps on pathfinder.

Once we have the token, we can use pathfinder v2 API to create a container by POSTing into `api/v2/ext_app/containers`.

This is the whole attributes that you can supply to v2 API when creating container as external apps:

```ruby
{
  "hostname": "p-test-01",
  "source": {
    "source_type": "image",       # can be image, migration or copy
    "mode": "local",              # can be local or pull. default is pull.
    "remote": {
      "name": "remote-server-01"
    },
    "fingerprint": "",
    "alias": "18.04"
  },
  "bootstrappers": []
}
```

Additional explanation for some of the attributes can be found in the next sections.

## Provisioning

Pathfinder currently supports LXD to provision your container. The `source` attribute can be used to configure it.

## Bootstrapping

The v2 API for external apps accept `bootstrappers` attribute to specify steps to bootstrap your container in sequential fashion. Right now it only supports chef solo as bootstrapper.

### Chef Solo

These are the required attributes that need to be supplied when using `chef-solo` as bootstrapper.

```ruby
{
  "bootstrappers": [
    {
      "bootstrap_type": "chef-solo",  # can be chef-solo
      "bootstrap_cookbooks_url": "",  # url of cookbooks for chef solo archived in *.tar.gz format
      "bootstrap_attributes": {"..."} # attributes for bootstrapping
    }
  ]
}
```

Behind the scene, pathfinder agent will use supplied attributes as parameters when invoking `chef-solo` command, e.g.

```sh
chef-solo \
  --config <SOLO_RB_PATH> \
  --node-name <HOSTNAME> \
  --recipe-url <COOKBOOKS_URL> \
  --json-attributes <ATTRIBUTES_FILE> \
  --logfile <LOG_FILE_LOCATION>
```

And because we need to supply a `solo.rb` configuration file when invoking `chef-solo`, the agent will create a simple `solo.rb` file like this one:

```ruby
file_cache_path "/path/to/put/cache"
cookbook_path "/path/to/extract/cookbooks/to"
```
