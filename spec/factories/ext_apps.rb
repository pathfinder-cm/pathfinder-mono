FactoryBot.define do
  factory :ext_app do
    sequence(:name) {|n| "ext_app_#{n}" }
    description { "Description" }
    association :user
    access_token { SecureRandom.urlsafe_base64(48) }
  end
end
