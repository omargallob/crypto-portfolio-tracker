class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.string :name
      t.string :api
      t.string :nickname
      t.timestamps
    end
  end
end
