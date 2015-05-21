class SnippetFile < ActiveRecord::Base
  belongs_to :snippet
  validates_presence_of :filename, :snippet, :content
end
