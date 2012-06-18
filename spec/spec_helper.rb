begin
  require 'spork'
rescue LoadError => e
end

def configure
  # Configure Rails Environment
  ENV["RAILS_ENV"] = "test"

  require File.expand_path("../dummy/config/environment.rb",  __FILE__)

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

  require "rails/test_help"
  require "rspec/rails"
  require 'factory_girl'
  require 'factories.rb'

  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.default_url_options[:host] = "test.com"

  Rails.backtrace_cleaner.remove_silencers!

  # Configure capybara for integration testing
  require "capybara/rails"
  Capybara.default_driver   = :rack_test
  Capybara.default_selector = :css

  # Load support files
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    require 'rspec/expectations'
    config.include RSpec::Matchers
    config.include Alchemy::Engine.routes.url_helpers
    config.mock_with :rspec
    config.use_transactional_fixtures = true
  end

end

def seed
  # This code will be run each time you run your specs.
  DatabaseCleaner.clean

  # Seed the database
  Alchemy::Seeder.seed!

end

if defined?(Spork)
  Spork.prefork  { configure }
  Spork.each_run { seed }
else
  configure
  seed
end
