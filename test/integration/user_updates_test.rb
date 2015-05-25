require 'test_helper'

class UserUpdatesTest < ActionDispatch::IntegrationTest
    self.use_transactional_fixtures = false
    def setup
        @user = users(:user_3)
        setup_for_js
    end

    def teardown
        super
        teardown_for_js
    end

    test "unauthorized access to settings page" do
        visit settings_path
        assert_equal login_path, current_path
    end

    test "unsuccessful profile update" do
        log_in_as @user
        visit settings_path
        fill_in "Name", with: "Bobby"
        fill_in "Email", with: "bobby@example.com"
        fill_in "Confirm existing password", with: "InvalidPassword"
        click_button "Update profile"
        assert page.has_selector?('span.errormsg')
    end

    test "successful profile update" do
        log_in_as @user
        visit settings_path
        fill_in "Name", with: "Bobby"
        fill_in "Email", with: "bobby@example.com"
        fill_in "Confirm existing password", with: "Password"   # correct password
        click_button "Update profile"
        assert page.has_text?("Successfully updated profile!")
    end

    test "wrong existing password on password update" do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "InvalidPassword"
        fill_in "New password", with: ""
        fill_in "Confirm new password", with: "NonMatchingPassword"
        click_button "Change password"
        assert find('span.errormsg').has_text?("Existing password is wrong")
    end

    test "non-matching passwords on password update" do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "Password"
        fill_in "New password", with: "BeefLasagna"
        fill_in "Confirm new password", with: "ChickenChop"
        click_button "Change password"
        assert find('span.errormsg').has_text?("Password confirmation doesn't match")
    end

    test "inadequate password complexity on password update" do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "Password"
        fill_in "New password", with: "beeflasagna"
        fill_in "Confirm new password", with: "beeflasagna"
        click_button "Change password"
        assert find('span.errormsg').has_text?("Password must contain at least 1 uppercase character")
    end

    test "successful password update" do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "Password"
        fill_in "New password", with: "MyNewPassword"
        fill_in "Confirm new password", with: "MyNewPassword"
        click_button "Change password"
        assert page.has_text?("Successfully changed password!")
    end
end
