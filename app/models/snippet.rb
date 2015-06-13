class Snippet < ActiveRecord::Base
    has_many :snippet_files, :dependent => :destroy
    has_many :group_snippets, dependent: :destroy
    has_many :groups, through: :group_snippets, dependent: :destroy
    validate :groups_valid

    belongs_to :user
    validates_presence_of :title
    validates :title, length: { maximum: 1024, too_long: "cannot have more than %{count} characters"}

    scope :priv, -> (priv) { where priv: priv }
    scope :permission, -> (current_user) { where user: current_user }

    def groups_valid
        groups.each do |group|
            unless self.user.active_groups.include?(group)
                errors.add :groups, "contain one you do not have permission for"
                return
            end
        end
    end
end
