# !/usr/bin/env bash

sudo apt-get update
echo "Install packages"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

echo "install ruby"
sudo apt-get install -y ruby-full

echo "Install chef"
gem install chef

cd /opt
sudo mkdir pathfinder
sudo chown vagrant:vagrant pathfinder
cd pathfinder
mkdir cookbooks
cd cookbooks

echo "Cloning all the cookbooks"
git clone https://github.com/chef-cookbooks/ark.git
git clone https://github.com/chef-cookbooks/mingw.git
git clone https://github.com/windowschefcookbooks/seven_zip.git
git clone https://github.com/chef-cookbooks/windows.git
git clone https://github.com/chef-cookbooks/build-essential.git
git clone https://github.com/chef-cookbooks/tar.git
git clone https://github.com/aogail/chef-zipfile.git
git clone https://github.com/pathfinder-cm/pathfinder-mono-cookbook.git
git clone https://github.com/pathfinder-cm/pathfinder-agent-cookbook.git
git clone https://github.com/pathfinder-cm/pathfinder-node-cookbook.git

mv chef-zipfile zipfile
mv pathfinder-mono-cookbook pathfinder-mono
mv pathfinder-agent-cookbook pathfinder-agent
mv pathfinder-node-cookbook pathfinder-node
cd /opt/pathfinder/

echo "Creating solo.rb file"
cat > solo.rb << EOF
root = File.absolute_path(File.dirname(__FILE__))

cookbook_path root + "/cookbooks"

EOF

echo "Creating pathfinder.json file"
cat > pathfinder.json << EOF
{
  "pathfinder-mono": {
    "env_vars": {
      "RAILS_ENV": "production",
      "RAILS_SERVE_STATIC_FILES": true,
      "SECRET_KEY_BASE": "c57555fbd65136035487445a72ef7229c4f5d4eddade6233ae20e45e0887541c4c30e753421cb037a71d640c4c8a6ac89165511d8da724cbc8ec20e36f51ac83",
      "TIMESTAMP_FORMAT": "%d-%m-%Y %H:%M",
      "PROD_DB_HOST": "127.0.0.1",
      "PROD_DB_PORT": 5432,
      "PROD_DB_NAME": "pathfinder_mono_production",
      "PROD_DB_POOL": 5,
      "PROD_DB_USER": "pathfinder-mono",
      "PROD_DB_PASS": "XXXXXXXXXXXXXX"
    }
  },
  "postgresql": {
    "config": {
      "listen_addresses": "*"
    }
  },
  "run_list": [
          "recipe[pathfinder-mono::db]",
          "recipe[pathfinder-mono::app]",
          "recipe[pathfinder-mono::scheduler]",
          "recipe[pathfinder-node::install]"

    ]
}
EOF

sudo chef-solo -c ./solo.rb -j ./pathfinder.json
