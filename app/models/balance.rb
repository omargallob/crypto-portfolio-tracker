class Balance < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :wallet
  has_many :orders
  has_many :movements

  def calculate_avg(total_buy_price, total_shares)
    number_with_precision((total_buy_price/total_shares), precision: 8)
  end

  def last_few_tx_are_relevant_ignore_rest(total_amount, last_tx)
    number_with_precision((total_amount), precision: 8).to_s == number_with_precision((last_tx), precision: 8).to_s
  end
end
