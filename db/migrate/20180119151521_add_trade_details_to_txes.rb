class AddTradeDetailsToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :tid, :string
    add_column :txes, :order_id, :string
    add_column :txes, :price, :string
    add_column :txes, :pair, :string
    add_column :txes, :fee_currency, :string
    add_column :txes, :fee_amount, :string
  end
end
