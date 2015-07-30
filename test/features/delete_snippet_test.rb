require "test_helper"

feature "DeleteSnippet" do
	before do
        @snippet = create(:snippet)
        @user = @snippet.user
        @invalid_user = create(:user)
        @admin = create(:user)
        @admin.is_admin = true
        @admin.save
    end
    
    
    scenario "Not logged in" do
        visit show_snippet_path(@snippet)
        unless all(".snippet-delete-link").empty?
            assert false, "There should be no delete link"
        end
    end

    scenario "User delete success", js: true do
        log_in_as @user
        visit show_snippet_path(@snippet)
    	find(".snippet-delete-link").click

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Content can't be blank")

    	current_path.must_equal show_user_path(@user.username), "User not redirected to add"
    	page.has_text?("Deleted snippet.").must_equal true, "Admin should be able to delete"
    end

    scenario "Admin delete success", js: true do
        log_in_as @admin
        visit show_snippet_path(@snippet)
        find(".snippet-delete-link").click

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Content can't be blank")

        current_path.must_equal show_user_path(@user.username), "User not redirected to add"
        page.has_text?("Deleted snippet.").must_equal true
    end

    scenario "Delete No Permission", js: true do
        log_in_as @invalid_user
        visit show_snippet_path(@snippet)
        unless all(".snippet-delete-link").empty?
            assert false, "There should be no delete link"
        end
    end

end