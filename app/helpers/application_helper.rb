module ApplicationHelper
  def title(text)
    page_tilte = ''
    page_tilte = "#{text} - " unless text.blank?
    page_tilte << 'Sunline'
  end

  # Updated for Bootstrap 4.6.2
  ALERT_TYPES = ['danger', 'info', 'success', 'warning']
  def bootstrap_flash_compat
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = 'success' if type == 'notice'
      type = 'danger'   if type == 'alert'
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, nil, class: "btn-close", "data-bs-dismiss": "alert", "aria-label": "Close") +
                           msg.html_safe, class: "alert alert-#{type} alert-dismissible fade show")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
