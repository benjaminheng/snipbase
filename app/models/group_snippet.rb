class GroupSnippet < ActiveRecord::Base
    belongs_to :group
    belongs_to :snippet
end
