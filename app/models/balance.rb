class Balance < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :wallet
  has_many :txes  

  delegate :trades, :movements, :valid, to: :txes

  def calculate_avg(total_buy_price, total_shares)
    number_with_precision((total_buy_price/total_shares), precision: 8)
  end

  def last_few_tx_are_relevant_ignore_rest(total_amount, last_tx)
    number_with_precision((total_amount), precision: 8).to_s == number_with_precision((last_tx), precision: 8).to_s
  end

  def self.invalidate_order_ids(order_ids)
    order_ids.each do |id|
      order = Trade.find_by_id(id)
      order.update_attribute(:invalidated, 1)
      
    end
    puts " |- invalidated order_ids: " + order_ids.join(",")
  end
end
