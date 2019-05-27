FactoryBot.define do
  factory :container do
    association :cluster
    sequence(:hostname) {|n| "cluster-#{n}" }
    sequence(:ipaddress) {|n| "10.0.0.#{n}" }
    image_alias { 'linux' }
    image_server { 'https://cloud-images.ubuntu.com/releases' }
    image_protocol { 'lxd' }
  end
end
