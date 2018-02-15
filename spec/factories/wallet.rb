require 'faker'

FactoryBot.define do
  factory :wallet do
    name 'USD'
    wallet_type 'exchange'
    association :exchange, factory: :exchange
  end

  factory :random_wallet, class: Wallet do
    name { Faker::Currency.code }
  end
end