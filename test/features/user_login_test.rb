require "test_helper"

feature "UserLogin" do
    before do
        @user = create(:user)
    end

    scenario "login with invalid credentials" do
        visit login_path
        log_in_with @user.username, "InvalidPassword"   # invalid credentials
        page.has_link?("Log in").must_equal true
    end

    scenario "login with valid credentials" do
        visit login_path
        log_in_with @user.username, "Password"          #valid credentials
        page.has_link?("Log out").must_equal true
    end

    private
    def log_in_with(username, password)
        visit login_path
        fill_in "Username", with: username
        fill_in "Password", with: password
        click_button "Log in"
    end
end
