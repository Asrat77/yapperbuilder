# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t yapperbuilder .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name yapperbuilder yapperbuilder

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base


WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD ["sh", "-c", "bundle exec rake db:create db:migrate && ./bin/rails server -b 0.0.0.0 -p 8080"]
