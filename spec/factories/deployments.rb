FactoryBot.define do
  factory :deployment do
    association :cluster
    sequence(:name) { |n| "deployment-#{n}" }
    count { 1 }
    definition { '' }
  end
end
