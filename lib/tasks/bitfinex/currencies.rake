require 'dotenv/tasks'
require 'dotenv/load'

namespace :bitfinex do
  desc 'bitfinex related tasks'
  namespace :currencies do
    desc 'load balances'
    task load: [:environment] do
      client = Bitfinex::Client.new
      types = client.balances.select { |hash| hash["amount"] != '0.0'}.map {|hash| hash['type']}.uniq      
      types.each do |t|
        puts t.upcase
        client.balances.select { |hash| hash["type"] == t && hash["amount"] != '0.0' }.map do |x|                             
          Wallet.create(
            wallet_type: t,
            name: x['currency'],
            amount: x["amount"],
            available: x["available"] 
          )
        end
      end
    end
    desc 'update balances'
    task update: [:environment] do
      client = Bitfinex::Client.new
      types = client.balances.select { |hash| hash["amount"] != '0.0'}.map {|hash| hash['type']}.uniq
      types.each do |t|
        puts t.upcase
        client.balances.select { |hash| hash["wallet_type"] == t && hash["amount"] != '0.0' }.map do |x|          
          currCurrency = Wallet.where(wallet_type: x['type'], name: x['currency']).first
          currCurrency.update_attributes( available: x["amount"], amount: x["available"])
        end
      end
    end
  end
end