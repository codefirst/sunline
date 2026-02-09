Sunline
===================

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://www.heroku.com/deploy?template=https://github.com/codefirst/sunline)


Install
----------------

Install dependencies:

```shell
$ bundle install --path .bundle --without development test
$ bin/yarn
```

Precompile assets:

```shell
$ bin/rails assets:precompile RAILS_ENV=production
```

Setup database:

```shell
$ bin/rails db:migrate RAILS_ENV=production
```

S3 settings

if you use S3 as storage, set several environment variables.

```shell
$ export ACTIVE_STORAGE_SERVICE=amazon
$ export AWS_BUCKET=bucket name
$ export AWS_ACCESS_KEY_ID=access key
$ export AWS_SECRET_ACCESS_KEY=secret access key
$ export AWS_REGION=ap-northeast-1
```

Slack integration

if you want to notify logs to a Slack channel.

```shell
$ export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxx/yyy/zzz
```

Run:

```shell
$ export OMNIAUTH_GITHUB_CLIENT_ID=Client ID
$ export OMNIAUTH_GITHUB_CLIENT_SECRET=Client Secret
$ export OMNIAUTH_GITHUB_ORGANIZATION=Some Organization # optional
$ bin/rails s -e production
```

and access to http://localhost:3000/

For developers
---------------

Setup database:

```shell
$ bin/rails db:migrate RAILS_ENV=test
```

Run server:

```shell
$ bin/dev
```

Run tests:

```shell
$ bin/rails spec
```

Run docker:

```shell
$ docker build -t sunline .
$ docker run -p 3000:3000 -e DATABASE_URL="postgresql://user:pass@localhost:5432/sunline_production?host=host.docker.internal" -e RAILS_FORCE_SSL=false -e RAILS_SERVE_STATIC_FILES=true -e OMNIAUTH_GITHUB_CLIENT_ID=xxx -e OMNIAUTH_GITHUB_CLIENT_SECRET=xxx sunline
```
