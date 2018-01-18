class Exchange < ApplicationRecord
  has_many :wallets, dependent: :destroy
  validates_presence_of :name
end
