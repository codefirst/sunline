class AddResultBytesToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :result_bytes, :integer

    Log.all.each do |log|
      raise 'update result_bytes failed' unless log.update_column(:result_bytes, log.result.bytesize)
    end
  end
end
