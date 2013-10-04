json.array!(@logs) do |log|
  json.extract! log, :host, :result, :script_id
  json.url log_url(log, format: :json)
end
