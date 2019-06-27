# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(
  username: 'admin',
  email: 'admin@pathfinder.com', 
  password: 'pathfinder',
  password_confirmation: 'pathfinder',
)

cluster = Cluster.create!(
  name: 'default',
  password: 'pathfinder',
  password_confirmation: 'pathfinder',
)

ext_app = ExtApp.create!(
  name: 'Pathfinder Interface',
  user_id: user.id,
  access_token: 'pathfinder',
)

remote = Remote.create!(
  name: 'ubuntu',
  server: 'https://cloud-images.ubuntu.com/release',
  protocol: 'simplestreams',
  auth_type: 'none',
  certificate: '',
)

source = Source.create!(
  source_type: 'image',
  mode: 'pull',
  remote_id: remote.id,
  fingerprint: '',
  alias: '18.04',
)
