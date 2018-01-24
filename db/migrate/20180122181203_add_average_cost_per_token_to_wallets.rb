class AddAverageCostPerTokenToWallets < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :avg_cost_per_unit, :string
  end
end
