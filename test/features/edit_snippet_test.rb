require "test_helper"

feature "EditSnippet" do
    before do
        @snippet = create(:snippet)
        @user = @snippet.user
        @admin = create(:user)
        @admin.is_admin = true
        @admin.save
    end

    scenario "Not logged in" do
        visit edit_snippet_path(@snippet)
        current_path.must_equal login_path, "User not redirected to login page."
    end

    #Currently admin can edit, change test according to code
    scenario "admin successful edit", js: true do
        log_in_as @admin
        visit edit_snippet_path(@snippet)
        fill_in "Title", with: "Edited Title"
        click_button "Save Snippet"

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Title can't be blank")
        current_path.must_equal show_snippet_path(@snippet), "User not redirected to show snippet page"

        page.has_text?("Edited Title").must_equal true
    end

    scenario "successful edit title of snippet file", js: true do
        login_and_goto_edit
        fill_in "Title", with: "Edited Title"
        click_button "Save Snippet"

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Title can't be blank")
        current_path.must_equal show_snippet_path(@snippet), "User not redirected to show snippet page"

        page.has_text?("Edited Title").must_equal true
    end

    scenario "successful edit content of snippet file", js: true do
        login_and_goto_edit
        edit_file_contents("New Content")
        click_button "Save Snippet"

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Content can't be blank")
        current_path.must_equal show_snippet_path(@snippet), "User not redirected to show snippet page"

        page.has_text?("New Content").must_equal true
    end

    scenario "successful deletion of a snippet file", js: true do
        login_and_goto_edit
        initialCount = all('.close').count
        all('.close')[1].click
        click_button "Save Snippet"

        # Force capybara to wait for javascript redirect to finish
        page.has_text?("Content can't be blank")
        current_path.must_equal show_snippet_path(@snippet), "User not redirected to show snippet page"
        all('.snippet-content').count.must_equal(initialCount-1);
    end

    scenario "unsuccessful edit title of snippet file", js: true do
        login_and_goto_edit
        fill_in "Title", with: ""
        click_button "Save Snippet"

        current_path.must_equal edit_snippet_path(@snippet);
        page.has_text?("Title can't be blank").must_equal true
    end

    scenario "unsuccessful edit content of snippet file", js: true do
        login_and_goto_edit

        @snippet.snippet_files[0].content.length.times do
            all('.snippet-editor')[0].native.send_key(:Backspace)
        end

        click_button "Save Snippet"
        page.has_text?("Content can't be blank").must_equal true
    end

    def login_and_goto_edit
        log_in_as @user
        visit edit_snippet_path(@snippet)
    end

    def edit_file_contents(content)
        all('.snippet-editor').each do |e|
            10.times do 
                e.native.send_key(:Backspace)
            end
            e.native.send_key(content)
        end
    end
end
