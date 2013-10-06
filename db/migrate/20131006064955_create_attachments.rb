class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :script_id
      t.attachment :upload

      t.timestamps
    end
  end
end
