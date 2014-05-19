class Log < ActiveRecord::Base
  belongs_to :script

  scope :by_host, lambda {|host|
    where(host: host).order(created_at: :desc)
  }

  def formatted_created_at
    return self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at
    ''
  end

  def hook_json(url)
    {script: self.script, log: self, url: url}.to_json(except: [:id, :guid, :script_id])
  end

  def self.all_hosts
    self.distinct.order(:host).pluck(:host)
  end
end
