# TradingPair contains the information relative to the pair - grouping txes by TradingPair allow to calculate 
# avg buy and sell price
# breakeven price

class TradingPair < ApplicationRecord
  belongs_to :balance
  has_many :trades, dependent: :destroy
end
