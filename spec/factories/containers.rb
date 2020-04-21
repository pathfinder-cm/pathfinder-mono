FactoryBot.define do
  factory :container do
    association :cluster
    sequence(:hostname) {|n| "cluster-#{n}" }
    sequence(:ipaddress) {|n| "10.0.0.#{n}" }
    association :source
    image_alias { 'linux' }
    bootstrappers { [
      { 'bootstrap_type' => 'none' }
    ] }
    container_type Container.container_types[:stateful]
  end
end
