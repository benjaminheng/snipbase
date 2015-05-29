ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "rack_session_access/capybara"
require 'capybara/poltergeist'
require 'database_cleaner'

Capybara.register_driver :poltergeist do |app|
    # Suppress console.log() messages
    Capybara::Poltergeist::Driver.new(app, :phantomjs_logger => File.open(File::NULL, "w"))
end
Capybara.javascript_driver = :poltergeist

# Applies to all test cases
class ActiveSupport::TestCase
    include FactoryGirl::Syntax::Methods
    ActiveRecord::Migration.check_pending!
    self.use_transactional_fixtures = false

    # Add more helper methods to be used by all tests here...

    # Simulate a login in as the specified user (for Capybara)
    def log_in_as(user)
        page.set_rack_session(user_id: user.id)
        visit root_path
    end

    def setup
        setup_js if defined?(metadata) && metadata[:js]
        DatabaseCleaner.start
    end

    def teardown
        DatabaseCleaner.clean
        teardown_js if defined?(metadata) && metadata[:js]
        Capybara.reset_sessions!
    end

    private
    def setup_js
        DatabaseCleaner.strategy = :truncation
    end

    private
    def teardown_js
        DatabaseCleaner.strategy = :transaction
    end
end
