require "test_helper"

feature "UserUpdate" do
    before do
        @user = create(:user)
    end

    scenario "unauthorized access to settings page" do
        visit settings_path
        current_path.must_equal login_path, "User not redirected to login page."
    end

    scenario "unsuccessful profile update", js: true do
        log_in_as @user
        visit settings_path
        fill_in "Name", with: "Bobby"
        fill_in "Email", with: "bobby@example.com"
        fill_in "Confirm existing password", with: "InvalidPassword"
        click_button "Update profile"
        page.has_selector?('span.errormsg').must_equal true
    end

    scenario "successful profile update", js: true do
        log_in_as @user
        visit settings_path
        fill_in "Name", with: "Bobby"
        fill_in "Email", with: "bobby@example.com"
        fill_in "Confirm existing password", with: "Password"   # correct password
        click_button "Update profile"
        page.has_text?("Successfully updated profile!").must_equal true
    end

    scenario "wrong existing password on password update", js: true do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "InvalidPassword"
        fill_in "New password", with: ""
        fill_in "Confirm new password", with: "NonMatchingPassword"
        click_button "Change password"
        page.has_text?("Existing password is wrong").must_equal true
    end

    scenario "non-matching passwords on password update", js: true do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "Password"
        fill_in "New password", with: "BeefLasagna"
        fill_in "Confirm new password", with: "ChickenChop"
        click_button "Change password"
        page.has_text?("Password confirmation doesn't match").must_equal true
    end

    scenario "inadequate password complexity on password update", js: true do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "Password"
        fill_in "New password", with: "short"
        fill_in "Confirm new password", with: "short"
        click_button "Change password"
        page.has_text?("must contain at least 6 characters").must_equal true
    end

    scenario "successful password update", js: true do
        log_in_as @user
        visit settings_path
        fill_in "Existing password", with: "Password"
        fill_in "New password", with: "MyNewPassword"
        fill_in "Confirm new password", with: "MyNewPassword"
        click_button "Change password"
        page.has_text?("Successfully changed password!").must_equal true
    end
end
