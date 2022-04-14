Sunline
===================

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

[![Code Climate](https://codeclimate.com/github/codefirst/sunline.png)](https://codeclimate.com/github/codefirst/sunline)

Install
----------------

Install dependencies:

    $ bundle install --path .bundle --without development test

Precompile assets:

    $ bundle exec rake assets:precompile RAILS_ENV=production

Setup database:

    $ bundle exec rake db:migrate RAILS_ENV=production

S3 settings

if you use S3 as storage, set several environment variables.

    $ export ACTIVE_STORAGE_SERVICE=amazon
    $ export AWS_BUCKET=bucket name
    $ export AWS_ACCESS_KEY_ID=access key
    $ export AWS_SECRET_ACCESS_KEY=secret access key
    $ export AWS_REGION=ap-northeast-1

Slack integration

if you want to notify logs to a Slack channel.

    $ export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxx/yyy/zzz

Run:

    $ export OMNIAUTH_GITHUB_CLIENT_ID=Client ID
    $ export OMNIAUTH_GITHUB_CLIENT_SECRET=Client Secret
    $ export OMNIAUTH_GITHUB_ORGANIZATION=Some Organization # optional
    $ export SUNLINE_LOCALE=ja    # in japanese only
    $ export SUNLINE_TIMEZONE=Tokyo    # rake time:zones:all
    $ bundle exec rails s -e production

and access to http://localhost:3000/

For developers
---------------

Setup database:

    $ bundle exec rake db:migrate RAILS_ENV=test

Run tests:

    $ bundle exec rake
