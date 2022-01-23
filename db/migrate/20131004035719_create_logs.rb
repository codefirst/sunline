class CreateLogs < ActiveRecord::Migration[4.2]
  def change
    create_table :logs do |t|
      t.string :host
      t.text :result
      t.integer :script_id

      t.timestamps
    end
  end
end
