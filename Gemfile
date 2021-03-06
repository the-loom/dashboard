source "https://rubygems.org"

ruby "2.6.6"

gem "rails", "5.2.4.5"

gem "pg", "~> 1.2"

gem "bootsnap", "~> 1.7", require: false
gem "puma", "~> 3.12"
gem "responders", "~> 3.0"
gem "sass-rails", "~> 6.0"
gem "therubyracer", "~> 0.12", platforms: :ruby
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Templating
gem "haml-rails", "~> 2.0"
gem "uglifier", "~> 4.2"

# Bug reporting
gem "rollbar", "~> 3.2"
gem "sentry-raven", "~> 3.1"

gem "request_store", "~> 1.5"

# Auithorization
gem "pundit", "~> 1.1"

group :development, :test do
  # Debugging
  gem "byebug", "~> 11.1", platform: :mri

  # Testing
  gem "factory_bot_rails", "~> 6.2"
  gem "rspec-rails", "~> 4.0"
  gem "shoulda-matchers", "~> 4.5"
end

gem "discard", "~> 1.2"

gem "dotenv-rails", "~> 2.7", groups: [:development, :test]

# Omniauth
gem "omniauth-github", "~> 2.0"
gem "omniauth-google-oauth2", "~> 0.8"
gem "omniauth-rails_csrf_protection", "~> 1.0"

# Forms
gem "simple_form", "~> 5.1"
gem "trix-rails", "~> 2.3", require: "trix" # remove?

group :development do
  # Gemfile health
  gem "ordinare", "~> 0.4"
  gem "pessimize", "~> 0.4"

  # Performance asessment
  gem "bullet", "~> 6.1"
  gem "rack-mini-profiler", "~> 2.3"

  # Debugging
  gem "better_errors", "~> 2.9"
  gem "web-console", "~> 3.7"

  # Creating dev data
  gem "ffaker", "~> 2.18"

  # Best practices
  gem "rails_best_practices", "~> 1.21"
  gem "rubocop-performance", "~> 1.11", require: false
  gem "rubocop-rails_config", "~> 1.6.0"
  gem "rubocop-rake", "~> 0.6", require: false
  gem "rubocop-rspec", "~> 2.4", require: false

  gem "annotate", "~> 3.1"
  gem "binding_of_caller", "~> 1.0"
  gem "listen", "~> 3.5"
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0"
end

# File management
gem "active_storage_validations", "~> 0.9"
gem "aws-sdk-s3", "~> 1.96"
gem "mini_magick", "~> 4.11"
gem "rubyzip", "~> 2.3"
gem "zip-zip", "~> 0.3"

# Syntax highlighting
gem "rouge", "~> 3.26"

# Tagging
gem "acts-as-taggable-on", "~> 7.0"

# Voting
gem "acts_as_votable", "~> 0.13"
