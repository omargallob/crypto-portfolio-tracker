require 'dotenv/tasks'

TRADING_PAIRS = ['USD', 'BTC', 'ETH']

desc 'bitfinex related tasks'
namespace :bitfinex do
  desc 'txs related tasks'
  namespace :txs do
    desc 'tx::trades related tasks'
    namespace :trades do
      desc 'import trades'
      task load: [:environment] do
        client = Bitfinex::Client.new
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          TRADING_PAIRS.each do |tp|
            unless currency.name.upcase == tp.upcase
              trading_pair = currency.name.upcase + tp.upcase
              trades = client.mytrades(trading_pair)
              if trades.count > 0
                tp = currency.balance.trading_pairs.find_or_create_by(name: trading_pair)
                trades.each do |t|

                  begin
                    order_type = t['type']
                    order_params = Hashie::Mash.new(t)
                    order_params.pair = trading_pair
                    order_params.order_type = order_type
                    order_params.balance_id = tp.balance_id
                    order = tp.trades.create(order_params.to_h.except!("type"))
                    puts order.inspect
                    order.save!
                  rescue =>  e
                    # ...will cause this code to run
                    puts t
                    puts "Exception Class: #{ e.class.name }"
                    puts "Exception Message: #{ e.message }"
                    puts "Exception Backtrace: #{ e.backtrace }"
                  end
                end
              end
            else
              next
            end
            sleep(10)
          end
        end
        puts 'Total Executed Orders added: ' + Trade.all.count.to_s
      end
      desc 'invalidate old txs'
      task invalidate: [:environment] do
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          currency.balance.invalidate_txes
        end
      end
      desc 'calculate weigthed avg cost per token'
      task calculate: [:environment] do
        Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
          currency.balance.calculate_weighted_avg_cost
        end
      end
    end
    desc 'tx::movement related tasks'
    namespace :movements do
      desc 'import movements'
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
      desc 'calculate movements value of currency at time'
      task calculate: [:environment] do 
        
      end
    end


  end
end
