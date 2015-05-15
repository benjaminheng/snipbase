class Snippet < ActiveRecord::Base
    has_many :snippet_files
    belongs_to :user
end
