require "test_helper"

feature "UserSignup" do
    scenario "successful signup" do
        visit register_path
        fill_in "Username", with: "bobthebuilder"
        fill_in "Name", with: "Bob"
        fill_in "Email", with: "bob@cartoonnetwork.com"
        fill_in "Password", with: "Password"
        fill_in "Confirm your password", with: "Password"
        click_button "Sign up"
        current_path.must_equal root_path, "Not redirected to '/' after signup."
        page.has_text?("Successfully registered").must_equal true, "Flash message not displayed."
        page.has_link?("Log out").must_equal true, "User is not logged in after signup."
    end

    scenario "non-matching passwords" do
        visit register_path
        fill_in "Username", with: "bobthebuilder"
        fill_in "Name", with: "Bob"
        fill_in "Email", with: "bob@cartoonnetwork.com"
        fill_in "Password", with: "Password"
        fill_in "Confirm your password", with: "DifferentPassword"
        click_button "Sign up"
        page.has_text?("Password confirmation doesn't match").must_equal true, "Password confirmation error message not displayed."
    end

    scenario "username already taken" do
        create(:user, username: "bobthebuilder")
        visit register_path
        fill_in "Username", with: "bobthebuilder"   # username taken
        fill_in "Name", with: "Bob"
        fill_in "Email", with: "bob@cartoonnetwork.com"
        fill_in "Password", with: "Password"
        fill_in "Confirm your password", with: "Password"
        click_button "Sign up"
        page.has_text?("Username has already been taken").must_equal true, "Username taken error message not displayed."
    end
end
