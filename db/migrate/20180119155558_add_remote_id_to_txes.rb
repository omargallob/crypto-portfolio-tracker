class AddRemoteIdToTxes < ActiveRecord::Migration[5.1]
  def change
    add_column :txes, :remote_id, :string
  end
end
