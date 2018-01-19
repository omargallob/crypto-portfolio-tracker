class CreateMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :movements do |t|
      t.references :balance
      t.string :movement_type
      t.string :timestamp
      t.string :fee
      t.string :timestamp_created
      t.string :txid
      t.string :description
      t.string :status
      t.string :address
      t.timestamps
    end
  end
end
