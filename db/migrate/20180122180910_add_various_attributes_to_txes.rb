class AddVariousAttributesToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :invalidated, :boolean
  end
end
