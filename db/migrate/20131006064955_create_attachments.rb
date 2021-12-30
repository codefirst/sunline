class CreateAttachments < ActiveRecord::Migration[4.2]
  def change
    create_table :attachments do |t|
      t.integer :script_id
      t.attachment :upload

      t.timestamps
    end
  end
end
