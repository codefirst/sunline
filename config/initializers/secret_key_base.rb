# Allows the app to start in Lambda without a credentials/master.key file.
# Set SECRET_KEY_BASE via environment variable or AWS SSM Parameter Store (via Crypteia).
Rails.application.configure do
  config.require_master_key = false
  config.secret_key_base ||= ENV['SECRET_KEY_BASE']
end
