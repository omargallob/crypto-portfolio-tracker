class Wallet < ApplicationRecord
  belongs_to :exchange
  has_one :balance

  after_create :create_balance

  def create_balance
    self.balance = Balance.new
  end
end
