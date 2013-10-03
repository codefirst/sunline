class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :body
      t.integer :created_by
      t.integer :updated_by
      t.string :guid
      t.boolean :archived

      t.timestamps
    end
  end
end
