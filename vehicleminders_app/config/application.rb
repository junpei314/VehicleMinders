require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VehicleMinders
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc
    # config.time_zone = 'Tokyo' # or any other time zone
    # config.active_record.default_timezone = :local
    config.eager_load_paths << Rails.root.join('app/workers')
  end
end
