class Wallet < ApplicationRecord
  belongs_to :exchange
  has_one :balance, dependent: :destroy

  after_create :create_balance

  validates_presence_of :name

  def create_balance
    self.balance = Balance.new
  end
end
