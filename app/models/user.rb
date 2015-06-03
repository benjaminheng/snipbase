class User < ActiveRecord::Base
    has_secure_password
    has_many :snippets

    #groups
    has_many :group_members
    has_many :groups, through: :group_members
    has_many :active_groups, -> { where.not group_members: { accepted: nil } },
             through: :group_members, class_name: "Group", source: :group
    has_many :pending_groups, -> { where group_members: { accepted: nil } },
             through: :group_members, class_name: "Group", source: :group

    #followers
    has_many :active_relationships, class_name: "Relationship", 
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", 
                                     foreign_key: "followed_id",
                                     dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships

    validates :username, presence: true, uniqueness: true, allow_nil: true
    validates :password, presence: true, confirmation: true, allow_nil: true
    validates :password_confirmation, presence: true, allow_nil: true
    validate :password_complexity

    def invite_to_group(group, invitee)
        # Only invite if user is the group owner
        if group.owner == self
            group.invite_user(invitee)
        end
    end

    def accept_group_invite(group)
        gm = group_members.find_by(user: self, group: group)
        gm.update(accepted: DateTime.now)
    end

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

    private
    def password_complexity
        return unless errors[:password].blank? && errors[:password_confirmation].blank?
        return if password.nil?

        if (password =~ /[A-Z]/).nil?  # check for uppercase
            errors.add :password, "must contain at least 1 uppercase character"
            return
        end
    end
end
