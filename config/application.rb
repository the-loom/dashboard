require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LoomDashboard
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    I18n.config.available_locales = :es
    I18n.config.default_locale = :es

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.after_initialize do |app|
      app.config.paths.add 'app/presenters', eager_load: true
    end

  end
end
