require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MasterThesisBeta
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  
  # rspec temp config - on scaffold commands, only generate cont specs and model fixtures
  config.generators do |g|
  	g.test_framework :rspec,
  	fixtures: true,
  	view_specs: false,
  	helper_specs: false,
  	routing_specs: false,
  	controller_specs: false,
  	request_specs: false
  	g.fixture_replacement :factory_girl, dir: "spec/factories"
  end

  config.active_job.queue_adapter = :delayed_job

  config.middleware.use Rack::Attack

  end
end
