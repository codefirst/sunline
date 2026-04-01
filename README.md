Sunline
===================

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://www.heroku.com/deploy?template=https://github.com/codefirst/sunline)


Install
----------------

Install dependencies:

```shell
$ bundle install --without development test
$ npm install
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

Deploy to AWS Lambda
---------------------

This app supports deployment to AWS Lambda via [Lamby](https://lamby.cloud/) and AWS SAM.

### Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with appropriate credentials
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
- An Amazon RDS PostgreSQL instance accessible from Lambda

### Environment variables

Set the following environment variables on the Lambda function (via the AWS Console, SAM template, or [AWS SSM Parameter Store](https://github.com/rails-lambda/crypteia)):

| Variable | Description |
|---|---|
| `SECRET_KEY_BASE` | Rails secret key base |
| `DATABASE_URL` | PostgreSQL connection URL (e.g. `postgresql://user:pass@host/dbname`) |
| `OMNIAUTH_GITHUB_CLIENT_ID` | GitHub OAuth App client ID |
| `OMNIAUTH_GITHUB_CLIENT_SECRET` | GitHub OAuth App client secret |
| `OMNIAUTH_GITHUB_ORGANIZATION` | (Optional) Restrict login to a specific GitHub organization |

### Deploy

```shell
# Deploy to staging (default)
$ ./bin/deploy-lambda

# Deploy to production
$ RAILS_ENV=production ./bin/deploy-lambda
```

The script will:

1. Bundle gems for production into `vendor/bundle`
2. Precompile assets
3. Build and push a Docker image to Amazon ECR
4. Deploy via AWS SAM (`sunline-staging` or `sunline-production` CloudFormation stack)

The Lambda Function URL is shown in the SAM deploy output as `RailsLambdaUrl`.
