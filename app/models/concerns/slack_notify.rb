module SlackNotify
  extend ActiveSupport::Concern

  included do
    after_create_commit :notify
  end

  def notify
    if ENV['SLACK_WEBHOOK_URL'].blank?
      Rails.logger.info "[SlackNotify] Log##{id}: SLACK_WEBHOOK_URL is blank, skipping"
      return
    end

    Rails.logger.info "[SlackNotify] Log##{id}: enqueuing SlackNotifyJob"
    SlackNotifyJob.perform_later(self)
    Rails.logger.info "[SlackNotify] Log##{id}: SlackNotifyJob.perform_later returned"
  end
end

