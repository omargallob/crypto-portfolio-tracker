class Balance < ApplicationRecord
  belongs_to :wallet
  has_many :orders
end
