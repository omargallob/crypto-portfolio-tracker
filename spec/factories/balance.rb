require 'faker'

FactoryBot.define do
  factory :balance do
    amount 100
    association :wallet, factory: :random_wallet
  end

  factory :random_balance, class: Wallet do
    amount {Faker::Number.decimal(2, 3) #=> "18.843"
  }
  end
end