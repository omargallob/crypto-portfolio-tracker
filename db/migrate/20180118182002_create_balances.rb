class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.references :wallet, foreign_key: true      
      t.float :amount
      t.float :avg_buy_price_in_btc
      t.float :avg_sell_price_in_btc
      t.timestamps
    end
  end
end
