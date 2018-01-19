class AddCurrencyToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :currency, :string
  end
end
