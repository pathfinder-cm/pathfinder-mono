FactoryBot.define do
  factory :deployment do
    association :cluster
    sequence(:name) { |n| "deployment-#{n}" }

    desired_num_replicas { 1 }
    min_available_replicas { 1 }

    definition {
      {
        "strategy": "RollingUpdate",
        "allow_failure": "false",
        "source": {
          "mode": "pull",              # can be local or pull. default is pull.
          "alias": "lxd-ubuntu-minimal-consul-1.1.0-8",
          "remote": {
            "name": "barito-registry",
          },
          "fingerprint": "",
          "source_type": "image",
        },
        "container_type": "stateless",
        "resource": {
          "cpu_limit": "0-2",
          "mem_limit": "500MB",
        },
        "bootstrappers": [
          {
            "bootstrap_type": "chef-solo",
            "bootstrap_attributes": {
              "consul": {
                "hosts": [],
              },
              "run_list": [],
            },
            "bootstrap_cookbooks_url": "https://github.com/BaritoLog/chef-repo/archive/master.tar.gz",
          }
        ],
        "healthcheck": {
          "type": "tcp",
          "port": 9500,
          "endpoint": "",
          "payload": "",
          "timeout": "",
        }
      }
    }
  end
end
