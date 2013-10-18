class AddMemoToLog < ActiveRecord::Migration
  def change
    add_column :logs, :memo, :text
  end
end
