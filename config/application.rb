require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'gouge/core_ext/boolean_typecast'

# Enable hirb in console
Class.new Rails::Railtie do
  console do |app|
    Hirb.enable
  end
end

module PathfinderMono
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Eager load lib path
    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib').join('exceptions')

    # Configure rails generators
    config.generators do |g|
      g.orm :active_record

      # Configure test framework behavior
      g.test_framework :rspec, :fixture => true
      g.fixture_replacement :factory_bot, :dir => "spec/factories"
    end
  end
end
