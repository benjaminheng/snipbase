class Group < ActiveRecord::Base
    belongs_to :owner, class_name: "User"
    has_many :group_members
    has_many :users, through: :group_members

    has_many :active_users, -> { where.not group_members: { accepted: nil } },
             through: :group_members, class_name: "User", source: :user
    has_many :pending_users, -> { where group_members: { accepted: nil } },
             through: :group_members, class_name: "User", source: :user

    def invite_user(user)
        group_members.create(group: self, user: user)
    end
end
