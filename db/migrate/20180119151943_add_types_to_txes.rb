class AddTypesToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :order_type, :string
    add_column :txes, :movement_type, :string
  end
end
