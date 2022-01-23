class CreateHooks < ActiveRecord::Migration[4.2]
  def change
    create_table :hooks do |t|
      t.string :url
      t.integer :script_id
      t.timestamps
    end
  end
end
