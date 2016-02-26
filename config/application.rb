require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsUpgrade
  class Application < Rails::Application
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

    config.time_zone = 'UTC'

    # Your secret key for verifying cookie session data integrity.
    # If you change this key, all old sessions will become invalid!
    # Make sure the secret is at least 30 characters and all random, 
    # no regular words or you'll be exposed to dictionary attacks.
    config.action_controller.session = {
      :session_key => '_trunk_session',
      :secret      => '9b1c27a35892d8fbbb50ed309d09c02962f56b739f3ce521c99df3c4f8a2f611bc21ab9fdce060de62b091b06b9e879a7b10a82ab908c286463659f73cace48f'
    }

    # Activate observers that should always be running
    # Please note that observers generated using script/generate observer need to have an _observer suffix
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :user_observer
  end
end

# Email receipients for the exception_notification plugin
ExceptionNotifier.exception_recipients = %w(webmaster)
ExceptionNotifier.sender_address = "\"TPKG Server App Error\""

require 'will_paginate'
require 'active_record_extensions'

AppConfig = ConfigurationManager.new_manager
if AppConfig.authentication_method == "restful-authentication"
  include AuthenticatedSystem
elsif AppConfig.authentication_method == "sso"
  include YPCAuthenticatedSystem
end
