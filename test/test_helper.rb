ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'
require "rack_session_access/capybara"
require 'database_cleaner'

Capybara.javascript_driver = :poltergeist

class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Simulate a login in as the specified user
    def log_in_as(user)
        if integration_test?
            # Save time by not always simulating the whole login process
            page.set_rack_session(user_id: user.id)
            visit root_path
        else
            session[:user_id] = user.id     # used in models/functional tests
        end
    end

    # Returns true if inside integration test
    private
    def integration_test?
        defined?(post_via_redirect)
    end
end

class ActionDispatch::IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL

    # IMPORTANT: Override to FALSE if testing javascript
    # Use transactions by default (faster)
    self.use_transactional_fixtures = true

    # Always reset sessions after each test
    def teardown
        Capybara.reset_sessions!
    end

    # sets the database cleaner strategy, and changes to a javascript driver
    def setup_for_js
        DatabaseCleaner.strategy = :truncation
        Capybara.current_driver = Capybara.javascript_driver
        DatabaseCleaner.start
    end

    # Cleans the database, resets the capybara driver and database cleaner strategy
    def teardown_for_js
        DatabaseCleaner.clean
        Capybara.current_driver = Capybara.default_driver
        DatabaseCleaner.strategy = :transaction
    end
end
