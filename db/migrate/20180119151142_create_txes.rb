class CreateTxes < ActiveRecord::Migration[5.1]
  def change
    create_table :txes do |t|
      t.references :balance, foreign_key: true
      t.string :timestamp
      t.string :type
      t.string :amount
      t.boolean :written_off

      t.timestamps
    end
  end
end
