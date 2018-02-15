require 'dotenv/tasks'

namespace :bitfinex do
  desc 'bitfinex::wallet related tasks'
  namespace :wallet do
    desc 'list each (crypto)currency'
    task list: [:environment] do
      SHITCOIN_LIST = ['BAT','FUN','GNT','IOT','MNA','SPK','TNB','XRP']
      wallets = []
      Wallet.all.each do |w|
        if SHITCOIN_LIST.include? w.name.upcase
          w.update_attribute(:is_penny_coin, 1)
        end
      end
    end
    desc 'create wallets for each (crypto)currency'
    task create: [:environment] do
      exchange = Exchange.first
      client = Bitfinex::Client.new
      balances = client.balances.select { |hash| hash["amount"] != '0.0'}
      types = balances.map {|hash| hash['type']}.uniq
      types.each do |t|
        puts t.upcase
        balances.select{|h| h['type']==t}.each do |x|
          puts x['currency'] + ': ' + x["amount"]
          w = Wallet.create(
            exchange: exchange,
            wallet_type: t,
            name: x['currency'],
            amount: x["amount"],
            available: x["available"]
          )
          w.save!
        end
      end
      puts 'Total Wallets added: ' + Wallet.all.count.to_s
    end
    desc 'update wallet balances'
    task update: [:environment] do
      client = Bitfinex::Client.new
      balances = client.balances.select { |hash| hash["amount"] != '0.0'}
      types = balances.map {|hash| hash['type']}.uniq
      types.each do |t|
        puts t.upcase
        client.balances.select { |hash| hash["type"] == t }.map do |x|
          wallet = Wallet.where(wallet_type: x['type'], name: x['currency']).first
          puts 'updated: '+ x['currency']
          puts wallet.inspect
          wallet.update_attributes( available: x["amount"], amount: x["available"])
        end
      end
    end
    desc 'show wallet balances'
    task show: [:environment] do
      wallets = Wallet.all.group_by(&:wallet_type)
      wallets.each do |k,v|
        puts ''
        puts k.upcase
        puts '*****************'
        v.each do |wallet|
          puts wallet.name.upcase
          puts ' |- Amount: ' + wallet.amount.to_s
          puts ' |- Pairs: ' unless k.upcase == "DEPOSIT"
          wallet.balance.trading_pairs.each do |tp|
            if tp.avg_buy_price != nil ||  tp.avg_sell_price != nil             
              
              puts ' |-- ' + tp.name
              puts ' |--- Avg Buy Price: ' + tp.avg_buy_price if tp.avg_buy_price != nil
              puts ' |--- Avg Sell Price: ' + tp.avg_sell_price if tp.avg_sell_price != nil
            end
          end
          
        end
      end
    end
  end
end
