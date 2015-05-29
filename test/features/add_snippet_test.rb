require "test_helper"

feature "AddSnippet" do
    self.use_transactional_fixtures = false
    before do
        @user = users(:user_1)
    end

  	scenario "Not logged in" do
	    visit add_path
	    current_path.must_equal login_path, "User not redirected to login page."
  	end

  	scenario "successful add single snippet file", js: true do
  		login_and_goto_add_path
  		fill_in "Title", with: "Test Title"
  		fill_in "File name", with: "File1"

  		add_file_contents

  		click_button "Create Snippet"

		flunk if page.has_text?("Content can't be blank")	
		current_path.must_equal show_snippet_path(Snippet.last), "User not redirected to show snippet page"
  	end

  	scenario "successful add multiple snippet files", js: true do
		login_and_goto_add_path
  		fill_in "Title", with: "Test Title"
  		fill_in "File name", with: "File1"
  		click_button "Add file"

  		add_file_contents

		click_button "Create Snippet"

		flunk if page.has_text?("Content can't be blank")
		current_path.must_equal show_snippet_path(Snippet.last), "User not redirected to show snippet page"
  	end

  	scenario "empty title on add snippet", js: true  do
		login_and_goto_add_path
		fill_in "File name", with: "File1"

		add_with_error "Title can't be blank"
	end

  	scenario "empty file content on add snippet", js: true  do
  		login_and_goto_add_path
  		fill_in "Title", with: "Test Title"
  		fill_in "File name", with: "File1"

  		add_with_error "Content can't be blank"
  	end

  	def add_file_contents
  		all('.snippet-editor').each do |e|
  			e.native.send_key('Duck')
  		end
  	end

    def login_and_goto_add_path
		log_in_as @user
		visit add_path
    end

    def add_with_error error_msg
		click_button "Create Snippet"
  		page.has_text?(error_msg).must_equal true
    end
end
