FactoryBot.define do
  factory :cluster do
    sequence(:name) {|n| "cluster_#{n}" }
  end
end
