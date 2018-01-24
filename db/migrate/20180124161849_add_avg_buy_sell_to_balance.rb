class AddAvgBuySellToBalance < ActiveRecord::Migration[5.1]
  def change
    add_column :balances, :avg_buy_price_per_unit, :string
    add_column :balances, :avg_sell_price_per_unit, :string
    add_column :balances, :avg_price_per_unit, :string
    add_column :balances, :breakeven_price, :string    
  end
end
