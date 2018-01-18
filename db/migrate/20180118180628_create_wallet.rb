class CreateWallet < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.belongs_to :exchange, index: true
      t.string :name
      t.string :ticker
      t.string :amount
      t.string :available
      t.string :wallet_type
      t.timestamps
    end
  end
end
