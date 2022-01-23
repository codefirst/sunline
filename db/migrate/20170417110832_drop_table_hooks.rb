class DropTableHooks < ActiveRecord::Migration[4.2]
  def change
    drop_table :hooks
  end
end
