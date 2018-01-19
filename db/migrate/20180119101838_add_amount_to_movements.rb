class AddAmountToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :amount, :string
  end
end
