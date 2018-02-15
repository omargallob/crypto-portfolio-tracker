# Balance holds the amount of tokens held, by adding all the amounts of txs for a wallet u can determine
# amount held

class Balance < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :wallet
  has_many :txes
  has_many :trading_pairs, dependent: :destroy

  delegate :trades, :movements, :valid, to: :txes

  def calculate_avg(total_buy_price, total_shares)
    number_with_precision((total_buy_price/total_shares), precision: 8)
  end

  def last_few_tx_are_relevant_ignore_rest(total_amount, last_tx)
    number_with_precision((total_amount), precision: 8).to_s == number_with_precision((last_tx), precision: 8).to_s
  end

  def invalidate_order_ids(order_ids)
    order_ids.each do |id|
      order = Trade.find_by_id(id)
      order.update_attribute(:invalidated, 1) if order
    end
    puts " |- invalidated order_ids: " + order_ids.join(",")
  end

  def invalidate_txes
    puts "\nCurrency: " + wallet.name.upcase
    total_number_tokens = 0
    total_fees = 0
    total_movements = 0
    total_movement_fees = 0
    order_ids = []
    txes.sort_by {|x| DateTime.strptime(x.timestamp, '%s')}.each do |order|
      order_ids << order.id
      if order.type == "Trade"
        row = " |- #{order.order_type} - #{order.amount.to_s} #{order.pair.first(3)} @ #{order.price.to_s} #{order.pair.last(3)}"
        if order.order_type == "Sell"
          puts row.red
          total_number_tokens -= order.amount.to_f
        else
          puts row.blue
          total_number_tokens += order.amount.to_f
        end
      else
        row = " |- #{order.movement_type} - #{order.amount.to_s} "
        if order.movement_type == "WITHDRAWAL"
          puts row.red
          total_movements -= order.amount.to_f
        else
          puts row.blue
          total_movements += order.amount.to_f
        end
      end
      if wallet.is_penny_coin && total_number_tokens < 1 && total_number_tokens > -1 #its nor 
        puts " |- Total amount: #{total_number_tokens} ~ 0"
        #have to invalidate following order_ids
        invalidate_order_ids(order_ids)
        order_ids = []
      end
      total_fees += order.fee_amount.to_f
    end
    total_calculated = total_number_tokens + total_movements - (total_movement_fees - total_fees)
    is_close = self.wallet.amount.to_f - total_calculated
    funding_account = Wallet.where(name: self.wallet.name, wallet_type: 'deposit').first
    puts " |-- Total in Funding : #{funding_account.amount.to_s}" if funding_account
    puts " |-- Total in Exchange : #{self.wallet.amount.to_s}"
    puts " |-- Total in Movements: #{total_movements - total_movement_fees}"
    puts " |-- Total Calculated  : #{total_calculated} "
    # puts " |-- Order IDs: #{order_ids.join(", ")}" if order_ids.count > 0
    puts " |-- is it close to summary  : #{is_close.to_s}"
  
  end

  def calculate_weighted_avg_cost
    puts "\nCurrency: " + self.wallet.name.upcase + ' ' + (wallet.amount.to_s)
    self.trading_pairs.each do |tp|
      puts " |- #{tp.name} " if tp.trades.valid.count > 0
      tp.trades.valid.group_by(&:order_type).each do |ot, orders|
        puts " |-- #{ot}"
        total_purchase_amount = total_number_of_shares_purchased = 0
        orders.each do |order|
          # date = DateTime.strptime(order.timestamp,'%s')
          total_purchase_amount += (order.amount.to_f * order.price.to_f)
          total_number_of_shares_purchased += order.amount.to_f
          puts ' |--- ' + order.amount.to_s + ' ' + tp.name.first(3) + ' @ ' + order.price.to_s + ' ' + tp.name.last(3)
        end
        puts ' |---- Last Fee Amount: ' + orders.last.fee_amount.to_s
        tx_total = (self.wallet.amount.to_f - orders.last.fee_amount.to_f)
        is_last = self.last_few_tx_are_relevant_ignore_rest(tx_total, wallet.amount)
        avg = self.calculate_avg(total_purchase_amount,total_number_of_shares_purchased)
        puts ' |---- Last Tx Total: ' + tx_total.to_s
        puts ' |---- Is last Tx: ' + is_last.to_s || orders.count == 1
        puts ' |---- Average '+ tp.name + ' ' + ot.upcase + ' price  = ' + avg.to_s
        if(ot == "Buy")          
          tp.update_attribute(:avg_buy_price, avg)
        else
          tp.update_attribute(:avg_sell_price, avg)
        end
      end
    end
  end
end
