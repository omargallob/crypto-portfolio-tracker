require 'dotenv/tasks'

namespace :bitfinex do
  desc 'bitfinex::wallet related tasks'
  namespace :wallet do
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
        client.balances.select { |hash| hash["type"] == t && hash["amount"] != '0.0' }.map do |x|
          wallet = Wallet.where(type_account: x['type'], name: x['currency']).first
          puts 'updated: '+ x['currency']
          wallet.update_attributes( available: x["amount"], amount: x["available"])
        end
      end
    end
    desc 'show wallet balances'
    task show: [:environment] do
      wallets = Wallet.all.group_by(&:wallet_type)
      wallets.each do |k,v|
        puts k.upcase
        v.each do |wallet|
          puts wallet.name + ': '+ wallet.amount
        end
      end
    end
  end
end
