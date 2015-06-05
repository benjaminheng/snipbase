class Snippet < ActiveRecord::Base
    has_many :snippet_files, :dependent => :destroy
    belongs_to :user
    validates_presence_of :title
    validates :title, length: { maximum: 1024, too_long: "cannot have more than %{count} characters"}
end
