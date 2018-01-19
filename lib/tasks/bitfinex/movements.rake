require 'dotenv/tasks'

namespace :bitfinex do
  desc 'bitfinex related tasks'
  namespace :movements do
    desc 'load movements'
    task load: [:environment] do
      client = Bitfinex::Client.new
      Wallet.all.select {|x| x.wallet_type == 'exchange'}.each do |currency|
        puts 'Currency: ' + currency.name.upcase
        trades = client.movements(currency.name.upcase)
        trades.each do |t|
          begin
            movement_type = t['type']
            movement_params = Hashie::Mash.new(t)
            movement_params.movement_type = movement_type
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