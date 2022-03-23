# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage(:branch)

  add_group 'Services', 'app/services'
end

require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'
require 'factory_bot_rails'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

WebMock.disable_net_connect!(allow_localhost: true)

DatabaseCleaner.strategy = :truncation

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
