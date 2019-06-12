FactoryBot.define do
  factory :remote do
    sequence(:name) {|n| "remote-#{n}" }
    server { 'https://cloud-images.ubuntu.com/releases' }
    protocol { 'lxd' }
    auth_type { 'tls' }
    certificate { 'certificate' }
  end
end
