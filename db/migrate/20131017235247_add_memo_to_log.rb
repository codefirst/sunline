class AddMemoToLog < ActiveRecord::Migration[4.2]
  def change
    add_column :logs, :memo, :text
  end
end
