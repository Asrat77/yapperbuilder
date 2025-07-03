# syntax=docker/dockerfile:1
# Use a slim base Ruby image
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim

# Set working directory
WORKDIR /rails

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    libyaml-dev \
    nodejs \
    yarn && \
    rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy app code
COPY . .

# Precompile assets (optional, for production)
# RUN bundle exec rake assets:precompile

# Expose Cloud Run default port
EXPOSE 8080

# Start the Rails app — use $PORT from Cloud Run
CMD ["sh", "-c", "bundle exec rake db:migrate && bundle exec rails server -b 0.0.0.0 -p 8080"]
