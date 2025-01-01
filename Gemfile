source 'https://rubygems.org'

ruby file: '.ruby-version'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '8.0.1'
gem 'puma'

gem 'devise'
gem 'omniauth-github', '~> 2.0.1'
gem 'omniauth-rails_csrf_protection', '~> 1.0.2'
gem 'octokit', '~> 9.2'
gem "faraday-retry", "~> 2.2"

gem 'sprockets-rails'
gem 'jsbundling-rails'
gem 'cssbundling-rails'

# Use Haml
gem 'haml-rails'

gem 'settingslogic'
gem 'slack-notifier'

group :development, :test do
  gem 'rake', '< 14.0'
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-collection_matchers'
end

group :production do
  gem 'pg', '~> 1.5'
end
gem 'aws-sdk-s3'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'kaminari'
