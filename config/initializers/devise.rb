Devise.setup do |config|
  require 'devise/orm/active_record'
  require_relative '../../app/models/settings'
  config.secret_key = Settings.devise_secret_key
  config.sign_out_via = :delete
  case Settings.omniauth.args
  when NilClass
    config.omniauth Settings.omniauth.provider.to_sym
  when Hash
    config.omniauth Settings.omniauth.provider.to_sym, Settings.omniauth.args
  when Array
    config.omniauth Settings.omniauth.provider.to_sym, *Settings.omniauth.args
  end
end
