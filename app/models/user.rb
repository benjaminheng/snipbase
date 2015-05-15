class User < ActiveRecord::Base
    has_many :snippets
    has_and_belongs_to_many :groups
end
