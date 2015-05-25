require 'test_helper'

class UserLoginsTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:user_1)
    end

    test "login with invalid credentials" do
        log_in_with @user.username, "InvalidPassword"  # invalid credentials
        assert page.has_link?("Log in")
    end

    test "login with valid credentials" do
        log_in_with @user.username, "Password"  # valid credentials
        assert page.has_link?("Log out")
    end

    private
    def log_in_with(username, password)
        visit login_path
        fill_in "Username", with: username
        fill_in "Password", with: password
        click_button "Log in"
    end
end
