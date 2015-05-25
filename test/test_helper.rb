ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Simulate a login in as the specified user
    def log_in_as(user, options = {})
        password = options[:password] || "Password"
        # Simulate a post request if inside an integration test,
        # else set the session store
        if integration_test?
            post login_path, session: { username: user.username, password: password }
        else
            session[:user_id] = user.id
        end
    end

    # Returns true if inside integration test
    def integration_test?
        defined?(post_via_redirect)
    end
end
