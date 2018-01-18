class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :balance, foreign_key: true
      t.string :tid
      t.string :order_id
      t.float :amount
      t.float :price
      t.float :price_in_usd
      t.string :timestamp
      t.string :pair
      t.string :fee_currency
      t.float :fee_amount
      t.string :order_type
      t.timestamps
    end
  end
end
