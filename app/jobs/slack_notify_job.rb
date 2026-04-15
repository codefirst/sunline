class SlackNotifyJob < ApplicationJob
  queue_as :default
  include ActionView::Helpers::NumberHelper

  def perform(log)
    return if ENV['SLACK_WEBHOOK_URL'].blank?

    lines = []
    lines << "Sunline registered a log. Last 3 lines are:"
    lines << '```'
    lines << log.result.split("\n").last(3)
    lines << '```'

    begin
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping lines.join("\n"), attachments: [{
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
    rescue => e
      Rails.logger.error e
    end
  end
end
