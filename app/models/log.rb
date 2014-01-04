class Log < ActiveRecord::Base
  belongs_to :script

  def formatted_created_at
    return self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at
    ''
  end

  def hook_json
    {script: self.script, log: self}.to_json(except: [:id, :guid, :script_id])
  end
end
