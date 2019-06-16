FactoryBot.define do
  factory :source do
    source_type { 'lxc-image' }
    mode { 'pull' }
    association :remote
    sequence(:fingerprint) {|n| "fingerprint-#{n}" }
    sequence(:alias) {|n| "alias-#{n}" }
  end
end
