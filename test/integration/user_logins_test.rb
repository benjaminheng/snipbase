require 'test_helper'

class UserLoginsTest < ActionDispatch::IntegrationTest
    include SessionsHelper

    test "login with invalid credentials" do
        get login_path
        assert_template 'sessions/login'
        post login_path, session: {username: 'NonexistantUser', password: 'Password'}
        assert_template 'sessions/login'
        get root_path
        assert_not logged_in?
    end

    test "login with valid credentials" do
        user = users(:user_1)
        get login_path
        post login_path, session: {username: user.username, password: 'password1'}
        assert_redirected_to root_path
        assert logged_in?
    end
end
