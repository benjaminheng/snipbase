class SnippetsController < ApplicationController
    before_filter :ensure_authenticated, only: ["new", "create", "edit"]
    before_filter :authenticate_edit_permission, only: ["edit", "update"]
    before_filter :authenticate_delete_permission, only: ["destroy"]

    def search
        referrer_path = URI(request.referer).path
        
        if referrer_path == root_path

            groups = current_user.active_groups
            @snippets = Snippet.permission(current_user)
            
        elsif referrer_path.start_with?("/user/")

            username = referrer_path.split('/')[-1]
            user = User.find_by(username: username)
            @snippets = get_snippets_for_user(user)

        elsif referrer_path.start_with?("/following")
            #Issit??
        elsif referrer_path.start_with?("/groups")
            #!?
        end

        @snippets = @snippets.search(params[:search_input]).order_desc

        @snippets = @snippets.lang(params[:languages]) unless params[:languages].empty?

        redirect_back_or_refresh_snippet
    end

    #These 2 methods will changed after groups are implemented.
    #currently only the Owner has permission to edit/delete
    def authenticate_edit_permission
		@snippet = Snippet.find(params[:id])

    	#Redirecting to root_path?? Or raise 404??
    	redirect_to root_path unless (current_user == @snippet.user || current_user.is_admin)
        #render :js => "window.location = '#{root_path}'" unless current_user == @snippet.user
    end

    def authenticate_delete_permission
    	@snippet = Snippet.find(params[:id])

		#Redirecting to root_path?? Or raise 404??
    	redirect_to root_path unless (current_user == @snippet.user || current_user.is_admin)
    end

	def new
        @snippet = Snippet.new
        render 'create'
	end
	
	def show
		@snippet = Snippet.find(params[:id])
		if params[:destroy]
    		destroy and return
  		end
	end

	def edit
		render 'update'
	end

	def update
		@snippet.update(snippet_params)
		process_snippets
	end

	def create
		@snippet = Snippet.new(snippet_params)
		@snippet.user = current_user
		process_snippets
	end

	def destroy
        snippet_owner = @snippet.user
		if @snippet.destroy
			type = :success
			msg = "Deleted snippet."
            if request.env['HTTP_REFERER'].end_with?(show_snippet_path)
            	flash[:success] = msg
                return respond_to_delete(snippet_owner)
            end
		else
			type = danger
			msg = @snippet.errors.full_messages[0]
		end
		redirect_back_or_refresh_messages(msg, type)
	end

    def download_raw
    	snip_file = SnippetFile.find(params[:file_id])
    	send_data(snip_file.content, filename: snip_file.filename, type: "text", disposition: "inline" )
    end

    private
    def get_snippets_for_user(user)
        if (current_user != user)  # only show public snippets
            return user.public_snippets
        end
        return user.snippets
    end

    private
    def redirect_back_or_refresh_snippet
        respond_to do |format|
            format.html { redirect_to :back }
            format.js { render 'shared/refresh_snippet' }
        end
    end


	private
    def respond_to_delete(snippet_owner)
        respond_to do |format|
            format.html { redirect_to show_user_path(current_user.username) }
            format.js { render :js => "window.location = '#{show_user_path(snippet_owner.username)}'" }
        end
    end

	private
	def process_snippets
		return refresh_message unless validate_and_save_snippets?

        # Do a javascript redirect to the "view snippet" page if add/edit is successful
    	respond_to_create
    end

	private 
	def respond_to_create
		respond_to do |format|
			format.html { redirect_to show_snippet_path(@snippet) }
			format.js { render :js => "window.location = '#{show_snippet_path(@snippet)}'" }
		end
	end

	private
	def validate_and_save_snippets?
		get_snippet_files
		return false unless set_snippet_file_names?
		return false unless snippet_valid?
		@snippet.snippet_files.destroy_all
		save_snippets
		true
	end

	private
	def get_snippet_files
		@snippet_files = []

		snippet_file_params_arr.each do |i|
			snippet_file = SnippetFile.new(snippet_file_params_permit(i))
			snippet_file.snippet = @snippet
			@snippet_files << snippet_file
		end
	end

	private
	def set_snippet_file_names?
		snippet_file_names = []
		
		#Populate the file name array
		@snippet_files.each do |i|
			snippet_file_names << i.filename unless i.filename.blank?
		end

		#If all file names are not unique, return false
		if snippet_file_names.uniq.length != snippet_file_names.length
		  	flash.now[:danger] = "File Names must be unique"
		  	return false
		end

		#Generates a file name if the file name is empty
		@snippet_files.each do |i|
			if i.filename.blank?
				new_file_name = generate_file_name
				while snippet_file_names.include?(new_file_name)
					new_file_name = generate_file_name
				end
				i.filename = new_file_name
			end
		end
		true
	end

	private
	def generate_file_name
		@counter ||= 0
		@counter = @counter + 1
		return "SnipFile#{@counter}"
	end

	private
	def snippet_valid?
		unless @snippet.valid?
			flash.now[:danger] = @snippet.errors.full_messages[0]
			return false
		end

		@snippet_files.each do |snippet_file|
			unless snippet_file.valid?
				flash.now[:danger] = snippet_file.errors.full_messages[0]
				return false
			end
		end

		true
	end

	private
	def save_snippets
		@snippet.save
		@snippet_files.each do |i|
			i.save
		end
	end

    private
    def refresh_message
        respond_to do |format|
            format.html { }
            format.js { render 'shared/refresh_message' }
        end
    end

	private
    def snippet_params
        params.require(:snippet).permit(:title, :private, group_ids: [])
    end

	private
	def snippet_file_params_permit snippet_file_param
		snippet_file_param.permit(:filename, :content, :language)
	end

	private
	def snippet_file_params_arr
		params.require(:snippet_files)
	end

end
