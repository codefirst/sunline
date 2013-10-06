class Log < ActiveRecord::Base
  belongs_to :script

  def formatted_created_at
    return self.created_at.to_s(:db) if self.created_at
    ''
  end
end
