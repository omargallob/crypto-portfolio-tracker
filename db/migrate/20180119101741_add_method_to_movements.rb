class AddMethodToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :method, :string
  end
end
