Sunline
===================

Install
----------------

Install dependencies:

    $ bundle install --path .bundle --without development test

Precompile assets:

    $ bundle exec rake assets:precompile RAILS_ENV=production

Setup database:

    $ bundle exec rake db:migrate RAILS_ENV=production

Run:

    $ export OMNIAUTH_PROVIDER=github
    $ export OMNIAUTH_ARGS="['Client ID','Client Secret']"
    $ export SUNLINE_LOCALE=ja    # in japanese only
    $ bundle exec rails s -e production

and access to http://localhost:3000/

For developers
---------------

Setup database:

    $ bundle exec db:migrate RAILS_ENV=test

Run tests:

    $ bundle exec rake
