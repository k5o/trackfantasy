require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trackfantasy
  class Application < Rails::Application
    config.autoload_paths += %W{#{config.root}/lib}
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.default_url_options = { host: 'trackfantasy.com' }
    config.action_mailer.perform_deliveries = true

    # React
    config.react.max_renderers = 10
    config.react.timeout = 20 #seconds
    config.react.react_js = lambda {File.read(::Rails.application.assets.resolve('react.js'))}
    config.react.component_filenames = ['components.js']
    config.react.addons = true
  end
end
