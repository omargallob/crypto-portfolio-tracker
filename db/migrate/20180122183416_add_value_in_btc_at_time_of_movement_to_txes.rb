class AddValueInBtcAtTimeOfMovementToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :value_in_btc_at_time_of_movement, :string
  end
end
