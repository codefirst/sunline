class CreateAttachments < ActiveRecord::Migration[4.2]
  def change
    create_table :attachments do |t|
      t.integer :script_id
      t.string :upload_file_name
      t.string :upload_content_type
      t.bigint :upload_file_size
      t.datetime :upload_updated_at

      t.timestamps
    end
  end
end
