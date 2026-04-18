class AddIndexesToScriptsAndAttachments < ActiveRecord::Migration[8.1]
  def change
    add_index :scripts, :guid, unique: true
    add_index :attachments, :script_id
  end
end
