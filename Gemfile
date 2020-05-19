source "https://rubygems.org"

ruby "2.6.1"

gem "rails", "~> 5.2"

gem "pg", "~> 1.2"

gem "bootsnap", "~> 1.4", require: false
gem "puma", "~> 3.12"
gem "responders", "~> 3.0"
gem "sass-rails", "~> 6.0"
gem "therubyracer", "~> 0.12", platforms: :ruby
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "uglifier", "~> 4.2"

# Bug reporting
gem "rollbar", "~> 2.25"
gem "sentry-raven", "~> 3.0"

gem "request_store", "~> 1.5"

# Auithorization
gem "pundit", "~> 1.1"

group :development, :test do
  # Debugging
  gem "byebug", "~> 11.1", platform: :mri

  # Testing
  gem "factory_bot_rails", "~> 5.2"
  gem "rspec-rails", "~> 4.0"
  gem "shoulda-matchers", "~> 4.3"
end

gem "discard", "~> 1.2"

gem "dotenv-rails", "~> 2.7", groups: [:development, :test]

# Omniauth
gem "omniauth-github", "~> 1.4"
gem "omniauth-google-oauth2", "~> 0.8"
gem "omniauth-rails_csrf_protection", "~> 0.1"

# Forms
gem "simple_form", "~> 5.0"
gem "trix-rails", "~> 2.2", require: "trix"

group :development do
  # Gemfile health
  gem "ordinare", "~> 0.4"
  gem "pessimize", "~> 0.4"

  # Performance asessment
  gem "bullet", "~> 6.1"
  gem "rack-mini-profiler", "~> 2.0"

  # Debugging
  gem "better_errors", "~> 2.7"
  gem "web-console", "~> 3.7"

  # Creating dev data
  gem "ffaker", "~> 2.14"

  # Best practices
  gem "rails_best_practices", "~> 1.20"
  gem "rubocop-i18n", "~> 2.0"
  gem "rubocop-performance", "~> 1.5", require: false
  gem "rubocop-rails_config", "~> 0.10"
  gem "rubocop-rake", "~> 0.5", require: false

  gem "annotate", "~> 3.1"
  gem "binding_of_caller", "~> 0.8"
  gem "listen", "~> 3.2"
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0"
end

# File management
gem "active_storage_validations", "~> 0.8"
gem "aws-sdk-s3", "~> 1.64"
gem "mini_magick", "~> 4.10"
gem "rubyzip", "~> 2.3"
gem "zip-zip", "~> 0.3"

# Syntax highlighting
gem "rouge", "~> 3.19"
