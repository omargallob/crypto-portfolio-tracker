require 'dotenv/tasks'

TRADING_PAIRS = ['USD', 'BTC', 'ETH']

namespace :bitfinex do
  desc 'bitfinex related tasks'
  namespace :trades do
    desc 'load balances'
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
                order = currency.balance.orders.create(order_params.to_h.except!("type"))
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
  end
end
