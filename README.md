Sunline
===================

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

[![Build Status](https://secure.travis-ci.org/codefirst/sunline.png?branch=master)](http://travis-ci.org/codefirst/sunline)
[![Code Climate](https://codeclimate.com/github/codefirst/sunline.png)](https://codeclimate.com/github/codefirst/sunline)
[![wercker status](https://app.wercker.com/status/97d6b83aa52d6abb800f96eb37115c20/s/ "wercker status")](https://app.wercker.com/project/bykey/97d6b83aa52d6abb800f96eb37115c20)

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

    $ export PAPERCLIP_STORAGE_TYPE=s3
    $ export AWS_BUCKET=bucket name
    $ export AWS_ACCESS_KEY_ID=access key
    $ export AWS_SECRET_ACCESS_KEY=secret access key

Run:

    $ export OMNIAUTH_PROVIDER=github
    $ export OMNIAUTH_ARGS="['Client ID','Client Secret']"
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
