module SlackNotify
  extend ActiveSupport::Concern
  include ActionView::Helpers::NumberHelper

  included do
    after_create :notify
  end

  def notify
    unless ENV['SLACK_WEBHOOK_URL'].blank?
      Thread.start do
        ActiveRecord::Base.connection_pool.with_connection do
          lines = []
          lines << "Sunline registered a log. Last 3 lines are:"
          lines << '```'
          lines << self.result.split("\n").last(3)
          lines << '```'

          begin
            notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
            notifier.ping lines.join("\n"), attachments: [{
              color: "#8daec2",
              fields: [
                {
                  title: "Script",
                  value: self.script.name,
                  short: true
                },
                {
                  title: "Uploaded",
                  value: self.formatted_created_at,
                  short: true
                },
                {
                  title: "Host",
                  value: self.host,
                  short: true
                },
                {
                  title: "Size",
                  value: number_to_human_size(self.result.bytesize),
                  short: true
                }
              ]
            }]
          rescue => e
            Rails.logger.error e
          end
        end
      end
    end
  end
end

