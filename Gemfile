source "https://rubygems.org"

ruby "2.6.1"

gem "rails", "~> 5.2.4"
gem "pg"
gem "puma", "~> 3.12"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "therubyracer", platforms: :ruby

gem "pundit"
gem "rollbar"
gem "request_store"

group :development, :test do
  gem "byebug", platform: :mri
  gem "bullet"
  gem "rubocop-rails_config"
  gem "rspec-rails", "~> 3.9"
  gem "shoulda-matchers", "~> 4.2"
end

gem "dotenv-rails", "2.7.5", groups: [:development, :test]
gem "omniauth-github", "1.3.0"
gem "omniauth-google-oauth2", "0.5.3"
gem "omniauth-rails_csrf_protection", "~> 0.1"
gem "discard", "~> 1.1"

gem "ffaker", "2.13.0"
gem "simple_form"

group :development do
  gem "rack-mini-profiler"
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2.1"
  gem "better_errors"
  gem "binding_of_caller"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "responders"
gem "bootsnap", require: false

gem "aws-sdk-s3"

gem "active_storage_validations"
gem "mini_magick", ">= 4.9.5"
