class SnippetFile < ActiveRecord::Base
  belongs_to :snippet
  validates_presence_of :filename, :snippet, :content
  scope :filename, -> (filename) { where filename: filename }
  scope :language, -> (language) { where language: langauge }
end
