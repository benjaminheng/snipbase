class User < ActiveRecord::Base
    has_many :snippets
    has_and_belongs_to_many :groups
    has_many :active_relationships, class_name: "Relationship", 
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", 
                                     foreign_key: "followed_id",
                                     dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships

    def follow(other_user)
        active_relationships.create(followed_id: other_user.id)
    end

    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
        return following.include?(other_user)
    end

    def followed_by?(other_user)
        return followers.include?(other_user)
    end
end
