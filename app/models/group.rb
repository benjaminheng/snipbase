class Group < ActiveRecord::Base
    belongs_to :owner, class_name: "User"
    has_many :group_members, dependent: :destroy
    has_many :users, through: :group_members, dependent: :destroy

    has_many :active_users, -> { where.not group_members: { accepted: nil } },
             through: :group_members, class_name: "User", source: :user
    has_many :pending_users, -> { where group_members: { accepted: nil } },
             through: :group_members, class_name: "User", source: :user

    def invite_user(user)
        group_members.create(group: self, user: user)
    end

    # Explicitly add a user to the group, bypassing the invite system
    # Currently used to add the creator (owner) to the group
    def add_user(user)
        group_members.create(group: self, user: user, accepted: DateTime.now)
    end
end
