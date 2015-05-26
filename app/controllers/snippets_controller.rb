class SnippetsController < ApplicationController
    before_filter :ensure_authenticated, only: ["new", "create", "show", "edit"]

	def new
        @snippet = Snippet.new
        render 'create'
	end
	
	def show
		@snippet = Snippet.find(params[:id])
	end

	def edit
		@snippet = Snippet.find(params[:id])
        render 'edit'
	end

	def save
		@snippet = Snippet.find(params[:id])

		snippet_file_params_arr.each do |i|
			snippet_file = SnippetFile.new(snippet_file_params_permit(i))
			snippet_file.snippet = @snippet
			set_file_name snippet_file
			@snippet_files << snippet_file
		end

		return respond_to_create unless snippet_valid?
	end

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

	def create
		@snippet = Snippet.new(snippet_params)
		@snippet.user = current_user
		@snippet_files = []

		snippet_file_params_arr.each do |i|
			snippet_file = SnippetFile.new(snippet_file_params_permit(i))
			snippet_file.snippet = @snippet
			set_file_name snippet_file
			@snippet_files << snippet_file
		end

		return respond_to_create unless snippet_valid?

		@snippet.save
		@snippet_files.each do |i|
			i.save
		end

        # Do a javascript redirect to the "view snippet" page if add is successful
        render :js => "window.location = 'snippets/#{@snippet.id}'"
	end

	private
	def set_file_name snippet_file
		language = snippet_file.language
		language_extension = file_extension language
		filename = snippet_file.filename
		@file_counter ||= {}

		if filename.blank?
			@file_counter[language] ||= 0
			@file_counter[language] += 1
			snippet_file.filename = "SnipFile#{@file_counter[language]}#{language_extension}"
		elsif !filename.end_with? language_extension
			snippet_file.filename = filename+language_extension
		end
	end

	private 
	def file_extension language #Shud have such a method in markup
		".txt"
	end

    private
    def respond_to_create
        respond_to do |format|
            format.html
            format.js 
        end
    end

	private
    def snippet_params
        params.require(:snippet).permit(:title, :private)
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
