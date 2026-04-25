module SlackNotify
  extend ActiveSupport::Concern

  included do
    after_create_commit :notify
  end

  def notify
    SlackNotifyJob.perform_later(self) unless ENV['SLACK_WEBHOOK_URL'].blank?
  end
end

