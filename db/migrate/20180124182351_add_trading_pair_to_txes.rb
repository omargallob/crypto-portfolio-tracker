class AddTradingPairToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :trading_pair_id, :integer
  end
end
