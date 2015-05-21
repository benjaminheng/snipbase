class AddContentColumnToSnippetFile < ActiveRecord::Migration
  def change
  	add_column :snippet_files, :content ,:string
  end
end
