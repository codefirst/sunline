class SlackNotifyJob < ApplicationJob
  queue_as :default
  include ActionView::Helpers::NumberHelper

  def perform(log)
    Rails.logger.info "[SlackNotifyJob] Log##{log.id} (host=#{log.host}): job started"

    if ENV['SLACK_WEBHOOK_URL'].blank?
      Rails.logger.info "[SlackNotifyJob] Log##{log.id}: SLACK_WEBHOOK_URL is blank, skipping"
      return
    end

    lines = []
    lines << "Sunline registered a log. Last 3 lines are:"
    lines << '```'
    lines << log.result.split("\n").last(3)
    lines << '```'

    begin
      Rails.logger.info "[SlackNotifyJob] Log##{log.id}: sending Slack notification"
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      responses = notifier.ping lines.join("\n"), attachments: [{
        color: "#8daec2",
        fields: [
          {
            title: "Script",
            value: log.script.name,
            short: true
          },
          {
            title: "Uploaded",
            value: log.formatted_created_at,
            short: true
          },
          {
            title: "Host",
            value: log.host,
            short: true
          },
          {
            title: "Size",
            value: number_to_human_size(log.result_bytes),
            short: true
          }
        ]
      }]
      responses.each do |response|
        Rails.logger.info "[SlackNotifyJob] Log##{log.id}: Slack API response HTTP #{response.code} #{response.body}"
      end
      Rails.logger.info "[SlackNotifyJob] Log##{log.id}: successfully sent"
    rescue => e
      Rails.logger.error "[SlackNotifyJob] Log##{log.id}: failed with #{e.class}: #{e.message}"
      Rails.logger.error "[SlackNotifyJob] Log##{log.id}: backtrace #{e.backtrace&.first(5)&.join(' | ')}"
    end
  end
end
