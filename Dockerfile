# syntax=docker/dockerfile:1
# check=error=true

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

FROM docker.io/library/ruby:4.0.2-slim@sha256:12f002ff598856284c9fd35526712d5431c47d60dd91eb3a00f9e01777c762d5 AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    ln -s /usr/lib/"$(uname -m)"-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables and enable jemalloc for reduced memory usage and latency.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems and Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install JavaScript dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Install application gems
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock .ruby-version ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile




# Final stage for app image
FROM base AS app

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

CMD ["./bin/rails", "server"]

# LWA
FROM public.ecr.aws/awsguru/aws-lambda-adapter:1.0.0@sha256:b4da35991627bdac98a81c377d0cc28e6989687359576dfda9f0b64be835d648 AS aws-lambda-adapter

# Final stage for Lambda
FROM app AS lambda

USER root
COPY --from=aws-lambda-adapter /lambda-adapter /opt/extensions/lambda-adapter
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y awscli jq && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN rm -rf /rails/tmp && ln -sf /tmp /rails/tmp
COPY ./bin/lambda-entrypoint.sh ./bin/lambda-entrypoint.sh
RUN chmod +x ./bin/lambda-entrypoint.sh
USER 1000:1000

CMD ["./bin/lambda-entrypoint.sh"]
