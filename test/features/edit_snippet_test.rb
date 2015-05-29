require "test_helper"

feature "EditSnippet" do
    self.use_transactional_fixtures = false
    before do
        @user = users(:user_1)
        @snippet = snippets(:snippet_1)
    end

    scenario "Not logged in" do
	    visit edit_snippet_path(@snippet)
	    current_path.must_equal login_path, "User not redirected to login page."
  	end

  	scenario "successful edit title of snippet file", js: true do
  		login_and_goto_edit
  		fill_in "Title", with: "Editted Title"
  		click_button "Save Snippet"

  		flunk if page.has_text?("Title can't be blank")
  		current_path.must_equal show_snippet_path(@snippet), "User not redirected to show snippet page"

  		Snippet.find(@snippet.id).title.must_equal("Editted Title")
  	end

  	scenario "successful edit content of snippet file", js:true do
  		login_and_goto_edit

  		edit_file_contents

  		click_button "Save Snippet"

  		flunk if page.has_text?("Content can't be blank")
  		current_path.must_equal show_snippet_path(Snippet.last), "User not redirected to show snippet page"
  		
  		Snippet.find(@snippet.id).snippet_files.each do |s_file|
  			s_file.content.must_equal("New Content")
  		end

  	end

  	scenario "successful edit delete a snippet file", js:true do
  		login_and_goto_edit

  		all('.close')[1].click

  		click_button "Save Snippet"

  		flunk if page.has_text?("Content can't be blank")
		current_path.must_equal show_snippet_path(Snippet.last), "User not redirected to show snippet page"

  		snip_files = Snippet.find(@snippet.id).snippet_files.order(:snippet_id)
  		snip_files.count.must_equal(2)
  		snip_files[0].content.must_equal("file_0")
  		snip_files[1].content.must_equal("file_2")
  	end

  	scenario "unsuccessful edit title of snippet file", js:true do
  		login_and_goto_edit
  		fill_in "Title", with: ""
  		click_button "Save Snippet"

  		flunk unless page.has_text?("Title can't be blank")
  		Snippet.find(@snippet.id).title.must_equal("Snippet_1")
  	end

  	scenario "unsuccessful edit content of snippet file", js:true do
  		login_and_goto_edit

  		10.times do
  			all('.snippet-editor')[1].native.send_key(:Backspace)
  		end

  		click_button "Save Snippet"
  		flunk unless page.has_text?("Content can't be blank")
  	end

  	def login_and_goto_edit
  		log_in_as @user
  		visit edit_snippet_path(@snippet)
  	end

  	def edit_file_contents
  		all('.snippet-editor').each do |e|
  			10.times do 
  				e.native.send_key(:Backspace)
  			end
  			e.native.send_key("New Content")
  		end
  	end
end
