module SnippetsHelper
	def has_edit_permission
		snippet = Snippet.find(params[:id])
		current_user == snippet.user
	end

	def has_delete_permission
		snippet = Snippet.find(params[:id])
		current_user == snippet.user
	end
end
