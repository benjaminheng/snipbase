require 'test_helper'

class UserSignupsTest < ActionDispatch::IntegrationTest
    test "invalid signup information" do
        get register_path
        assert_template 'users/register'
        assert_no_difference "User.count" do
            post register_path, user: { username: "bobthebuilder", name: "Bob",
                                        email: "bob@example.com", password: "Password",
                                        password_confirmation: "different"}
        end
        assert_not_empty assigns(:user).errors[:password_confirmation]
        assert_template 'users/register'
    end

    test "valid signup information" do
        get register_path
        assert_template 'users/register'
        assert_difference "User.count" do
            post register_path, user: { username: "bobthebuilder", name: "Bob",
                                        email: "bob@example.com", password: "Password",
                                        password_confirmation: "Password"}
        end
        assert_redirected_to "/"
    end
end
