# syntax=docker/dockerfile:1
# Use a slim base Ruby image
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    sqlite3 \
    libsqlite3-dev \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]
