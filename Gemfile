source "https://rubygems.org"

ruby "2.6.1"

gem "rails", "~> 5.2.0"
gem "pg"
gem "puma", "~> 3.0"
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
  gem "rspec-rails", "~> 3.5"
  gem "shoulda-matchers", "~> 3.1"
end

gem "dotenv-rails", "2.5.0", groups: [:development, :test]
gem "omniauth-github", "1.3.0"
gem "omniauth-google-oauth2", "0.5.3"
gem "omniauth-rails_csrf_protection", "~> 0.1"
gem "discard", "~> 1.0"

gem "ffaker", "2.10.0"

group :development do
  gem "rack-mini-profiler"
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.1.5"
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
