require "test_helper"

feature "DeleteSnippet" do
	before do
        @snippet = create(:snippet)
        @user = @snippet.user
    end
    
    # In progress. Permissions not yet set
    #scenario "Not logged in" do
    #    visit show_snippet_path(@snippet)
    #    current_path.must_equal login_path, "User not redirected to login page."
    #end

    scenario "Delete success", js: true do
    	login_and_goto_show
    	find(".snippet-delete-link").click

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Content can't be blank")

    	current_path.must_equal show_user_path(@user.username), "User not redirected to add"
    	page.has_text?("Deleted snippet.").must_equal true
    end

    def login_and_goto_show
        log_in_as @user
        visit show_snippet_path(@snippet)
    end
end