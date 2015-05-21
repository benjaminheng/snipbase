class Snippet < ActiveRecord::Base
    has_many :snippet_files, :dependent => :destroy
    belongs_to :user
    validates_presence_of :title
end
