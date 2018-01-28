class CreateTradingPairs < ActiveRecord::Migration[5.1]
  def change
    create_table :trading_pairs do |t|
      t.references :balance
      t.string :name
      t.string :avg_sell_price
      t.string :avg_buy_price
      t.string :breakeven_price

      t.timestamps
    end
  end
end
