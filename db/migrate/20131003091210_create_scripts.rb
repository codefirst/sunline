class CreateScripts < ActiveRecord::Migration[4.2]
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :body
      t.integer :created_by_id
      t.integer :updated_by_id
      t.string :guid
      t.boolean :archived

      t.timestamps
    end
  end
end
