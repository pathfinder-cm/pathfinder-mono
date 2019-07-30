FactoryBot.define do
  factory :deployment do
    name        { Faker::Lorem.word.underscore }
    replicas    { [1, 3, 5].sample }
    label       { Faker::Lorem.word.underscore }
    status      { Deployment.statuses[:pending] }
    strategy    { { "type": "RollingUpdate", "rollingUpdate": { "maxSurge": 1, "maxUnavailable": 0 } } }
  end
end
