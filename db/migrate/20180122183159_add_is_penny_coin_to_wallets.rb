class AddIsPennyCoinToWallets < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :is_penny_coin, :boolean
  end
end
