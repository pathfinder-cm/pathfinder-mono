FactoryBot.define do
  factory :user do
    sequence(:username) {|n| "user_#{n}" }
    sequence(:email) {|n| "user_#{n}@example.com" }
    password "test1234"
    password_confirmation "test1234"
  end
end
