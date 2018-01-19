class AddMovementDetailsToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :fee, :string
    add_column :txes, :timestamp_created, :string
    add_column :txes, :txid, :string
    add_column :txes, :description, :text
    add_column :txes, :status, :string
    add_column :txes, :address, :string
    add_column :txes, :currency, :string
    add_column :txes, :method, :string
  end
end
