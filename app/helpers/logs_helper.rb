module LogsHelper
  def post_hooks(log)
    json = log.hook_json(log_url(log))

    log.script.hooks.each do |hook|
      begin
        Faraday.post hook.url, payload: json
      rescue => e
        logger.error e
      end
    end
  end
end
