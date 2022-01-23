class DeviseCreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table(:users) do |t|
      t.string :name, :null => false
      t.string :nickname, :null => false
      t.timestamps
    end
  end
end
