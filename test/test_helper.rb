ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "rack_session_access/capybara"
require 'capybara/poltergeist'
require 'database_cleaner'

Capybara.javascript_driver = :poltergeist

# Applies to all test cases
class ActiveSupport::TestCase
    ActiveRecord::Migration.check_pending!
    fixtures :all

    # Add more helper methods to be used by all tests here...
end


# Applies to Capybara feature tests only
class Capybara::Rails::TestCase
    # Simulate a login in as the specified user (for Capybara)
    def log_in_as(user)
        page.set_rack_session(user_id: user.id)
        visit root_path
    end

    def setup
        setup_js if metadata[:js]
    end

    def teardown
        teardown_js if metadata[:js]
        Capybara.reset_sessions!
        Capybara.use_default_driver
    end

    private
    def setup_js
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.start
    end

    private
    def teardown_js
        DatabaseCleaner.clean
        DatabaseCleaner.strategy = :transaction
    end
end

