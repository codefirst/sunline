Devise.setup do |config|
  require 'devise/orm/active_record'
  require_relative '../../app/models/settings'
  config.secret_key = Settings.devise_secret_key
  config.sign_out_via = :delete
  config.omniauth :github, Settings.omniauth.github.client_id, Settings.omniauth.github.client_secret, scope: 'read:org'
end
