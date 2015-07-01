class User < ActiveRecord::Base
    has_secure_password
    has_many :snippets

    #groups
    has_many :group_members, dependent: :destroy
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

    validates :username, presence: true, uniqueness: true, allow_nil: true,
              format: {with: /\A[a-zA-Z0-9_-]+\z/, message: "can only contain alphanumeric characters, dashes and underscores"},
              length: { maximum: 32, too_long: "cannot have more than %{count} characters"}
    validates :name, length: { maximum: 64, too_long: "cannot have more than %{count} characters"}
    validates :password, presence: true, confirmation: true, allow_nil: true
    validates :password_confirmation, presence: true, allow_nil: true
    validate :password_complexity

    scope :order_desc, -> { order(created_at: :desc) }

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

    def decline_group_invite(group)
        gm = group_members.find_by(user: self, group: group)
        gm.destroy()
    end

    def leave_group(group)
        if group.active_users.include?(self)
            group.remove_user(self)
        end
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

    def public_snippets 
        conditions = {user: self, private: false}
        return Snippet.where(conditions).order_desc
    end

    def following_snippets
        return Snippet.where('user_id IN (?)', self.following.select('id')).has_view_permission(self)
    end

    private
    def password_complexity
        return unless errors[:password].blank? && errors[:password_confirmation].blank?
        return if password.nil?

        #if (password =~ /[A-Z]/).nil?  # check for uppercase
            #errors.add :password, "must contain at least 1 uppercase character"
            #return
        #end
        if (password.length < 6)
            errors.add :password, "must contain at least 6 characters"
            return
        end
    end
end
