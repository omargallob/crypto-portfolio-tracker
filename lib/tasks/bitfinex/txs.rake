require 'dotenv/tasks'

TRADING_PAIRS = ['USD', 'BTC', 'ETH']

desc 'bitfinex related tasks'
namespace :bitfinex do
  desc 'txs related tasks'
  namespace :txs do
    desc 'load tx::trades'
    namespace :trades do
      task load: [:environment] do
        client = Bitfinex::Client.new
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          TRADING_PAIRS.each do |tp|
            unless currency.name.upcase == tp.upcase
              trading_pair = currency.name.upcase + tp.upcase
              trades = client.mytrades(trading_pair)
              trades.each do |t|

                begin
                  order_type = t['type']
                  order_params = Hashie::Mash.new(t)
                  order_params.pair = trading_pair
                  order_params.order_type = order_type
                  order = currency.balance.trades.create(order_params.to_h.except!("type"))
                  puts order.inspect
                  order.save
                rescue =>  e
                  # ...will cause this code to run
                  puts t
                  puts "Exception Class: #{ e.class.name }"
                  puts "Exception Message: #{ e.message }"
                  puts "Exception Backtrace: #{ e.backtrace }"
                end
              end
            else
              next
            end
            sleep(10)
          end
        end
        puts 'Total Executed Orders added: ' + Order.all.count.to_s
      end
      desc 'calculate amount'
      task calculate: [:environment] do
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          puts "\nCurrency: " + currency.name.upcase
          total_number_tokens = 0
          total_fees = 0
          total_movements = 0
          total_movement_fees = 0
          order_ids = []
          currency.balance.txes.sort_by {|x| DateTime.strptime(x.timestamp, '%s')}.each do |order|          
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

            # if total_number_tokens < 1
            #   puts " |- Total amount: #{total_number_tokens}"
            # end
            total_fees += order.fee_amount.to_f
          end
          total_calculated = total_number_tokens + total_movements - (total_movement_fees - total_fees)
          is_close = currency.amount.to_f - total_calculated
          funding_account = Wallet.where(name: currency.name, wallet_type: 'deposit').first
          puts " |-- Total in Funding : #{funding_account.amount.to_s}" if funding_account
          puts " |-- Total in Exchange : #{currency.amount.to_s}"
          puts " |-- Total in Movements: #{total_movements - total_movement_fees}"
          puts " |-- Total Calculated  : #{total_calculated} "
          # puts " |-- Order IDs: #{order_ids.join(", ")}" if order_ids.count > 0
          puts " |-- is it close to summary  : #{is_close.to_s}"
        end
      end
      desc 'show trades'
      task show: [:environment] do 
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          puts "\nCurrency: " + currency.name.upcase + ' ' + (currency.amount.to_s)
          currency.balance.trades.group_by(&:order_type).each do |k, o|
            puts ' - ' + k
            o.group_by(&:pair).each do |p,orders|
              puts ' |- ' + p
              # average_cost_per_share = total_purchase_amount / total_number_of_shares_purchased
              total_purchase_amount = total_number_of_shares_purchased = 0
              orders.each do |order|
                # date = DateTime.strptime(order.timestamp,'%s')
                total_purchase_amount += (order.amount.to_f * order.price.to_f)
                total_number_of_shares_purchased += order.amount.to_f
                puts ' |-- ' + order.amount.to_s + ' ' + p.first(3) + ' @ ' + order.price.to_s + ' ' + p.last(3)
              end
              puts ' |--- Last Fee Amount: ' + orders.last.fee_amount.to_s
              tx_total = (currency.amount.to_f - orders.last.fee_amount.to_f)
              is_last = currency.balance.last_few_tx_are_relevant_ignore_rest(tx_total, currency.amount)
              avg = currency.balance.calculate_avg(total_purchase_amount,total_number_of_shares_purchased)
              puts ' |--- Last Tx Total: ' + tx_total.to_s
              puts ' |--- Is last Tx: ' + is_last.to_s || orders.count == 1
              puts ' |--- Average '+ p + ' ' + k.upcase + ' price  = ' + avg.to_s
            end
          end
        end
      end
    end
    namespace :movements do 
      task load: [:environment] do
        client = Bitfinex::Client.new
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          puts 'Currency: ' + currency.name.upcase
          trades = client.movements(currency.name.upcase)
          trades.each do |t|
            begin
              movement_type = t['type']
              movement_id = t['id']
              movement_params = Hashie::Mash.new(t)
              movement_params.movement_type = movement_type
              movement_params.remote_id = movement_id
              movement = currency.balance.movements.create(movement_params.to_h.except!("type"))
              puts movement.inspect
              movement.save
            rescue =>  e
              # ...will cause this code to run
              puts t
              puts "Exception Class: #{ e.class.name }"
              puts "Exception Message: #{ e.message }"
              puts "Exception Backtrace: #{ e.backtrace }"
            end
          end
          sleep(5)
        end
        puts 'Total Movements added: ' + Movement.all.count.to_s
      end
    end
  end
end
