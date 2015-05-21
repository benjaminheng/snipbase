class SetDefaultValueToSnippetFile < ActiveRecord::Migration
  def change
  	change_column_default :snippet_files, :score, 0
  end
end
