source "https://rubygems.org"

ruby "2.7.4"

gem "rails", "6.1.4.4"

gem "pg", "~> 1.2"

gem "bootsnap", "~> 1.9", require: false
gem "puma", "~> 4.3"
gem "responders", "~> 3.0"
gem "sass-rails", "~> 6.0"
gem "therubyracer", "~> 0.12", platforms: :ruby
gem "execjs", "~> 2.8.1"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Templating
gem "haml-rails", "~> 2.0"
gem "uglifier", "~> 4.2"

# Bug reporting
gem "rollbar", "~> 3.2"
gem "sentry-raven", "~> 3.1"

gem "request_store", "~> 1.5"

# Auithorization
gem "pundit", "~> 2.1"

group :development, :test do
  # Debugging
  gem "byebug", "~> 11.1", platform: :mri

  # Testing
  gem "factory_bot_rails", "~> 6.2"
  gem "rspec-rails", "~> 5.0"
  gem "shoulda-matchers", "~> 5.1"
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
  gem "bullet", "~> 7.0"
  gem "rack-mini-profiler", "~> 2.3"

  # Debugging
  gem "better_errors", "~> 2.9"
  gem "web-console", "~> 3.7"

  # Creating dev data
  gem "ffaker", "~> 2.20"

  # Best practices
  gem "rails_best_practices", "~> 1.21"
  gem "rubocop-performance", "~> 1.11", require: false
  gem "rubocop-rails_config", "~> 1.8.0"
  gem "rubocop-rake", "~> 0.6", require: false
  gem "rubocop-rspec", "~> 2.7", require: false
  gem "fasterer"

  gem "annotate", "~> 3.1"
  gem "binding_of_caller", "~> 1.0"
  gem "listen", "~> 3.7"
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0"
end

# File management
gem "active_storage_validations", "~> 0.9"
gem "aws-sdk-s3", "~> 1.111"
gem "image_processing", "~> 1.2"
gem "mini_magick", "~> 4.11"
gem "rubyzip", "~> 2.3"
gem "zip-zip", "~> 0.3"

# Syntax highlighting
gem "rouge", "~> 3.26"

# Tagging
gem "acts-as-taggable-on", "~> 7.0"

# Voting
gem "acts_as_votable", "~> 0.13"
