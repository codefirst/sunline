class Log < ActiveRecord::Base
  include SlackNotify

  belongs_to :script

  before_save :set_result_bytes

  scope :by_host, lambda {|host|
    where(host: host).order(created_at: :desc)
  }

  scope :select_without_result, -> { select(Log.column_names.reject { |c| c == 'result' }) }

  def formatted_created_at
    return self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at
    ''
  end

  def self.all_hosts
    self.distinct.order(:host).pluck(:host)
  end

  def as_csv_row
    [host, formatted_created_at, number_to_human_size(result_bytes)]
  end

  private

  def set_result_bytes
    self.result_bytes = self.result&.size || 0
  end
end
