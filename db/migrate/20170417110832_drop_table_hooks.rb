class DropTableHooks < ActiveRecord::Migration
  def change
    drop_table :hooks
  end
end
