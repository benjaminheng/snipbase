class Group < ActiveRecord::Base
    belongs_to :owner, class_name: "User"
    has_many :group_members, dependent: :destroy
    has_many :users, through: :group_members, dependent: :destroy
    has_many :group_snippets, dependent: :destroy
    has_many :snippets, through: :group_snippets, dependent: :destroy

    has_many :active_users, -> { where.not group_members: { accepted: nil } },
             through: :group_members, class_name: "User", source: :user
    has_many :pending_users, -> { where group_members: { accepted: nil } },
             through: :group_members, class_name: "User", source: :user
    validates :name, presence: true,
                     format: {with: /\A[a-zA-Z0-9 _-]+\z/, message: "can only contain alphanumeric characters, dashes and underscores"},
                     length: { maximum: 32, too_long: "cannot have more than %{count} characters"}

    def invite_user(user)
        group_members.create(group: self, user: user)
    end

    # Explicitly add a user to the group, bypassing the invite system
    # Currently used to add the creator (owner) to the group
    def add_user(user)
        group_members.create(group: self, user: user, accepted: DateTime.now)
    end

    # Called when user leaves group or is removed
    def remove_user(user)
        group_members.find_by(group: self, user: user).destroy
    end

    def add_snippet(snippet)
        self.snippets.push(snippet)
    end

    def remove_snippet(snippet)
        self.snippets.destroy(snippet)
    end
end
