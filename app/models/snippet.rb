class Snippet < ActiveRecord::Base
    has_many :snippet_files, :dependent => :destroy
    has_many :group_snippets, dependent: :destroy
    has_many :groups, through: :group_snippets, dependent: :destroy
    validate :groups_valid

    belongs_to :user
    validates_presence_of :title
    validates :title, length: { maximum: 1024, too_long: "cannot have more than %{count} characters"}

    scope :priv, -> (priv) { where priv: priv }
    
    scope :has_view_permission, -> (current_user) {
        ids = current_user.groups.select("id")
        if ids.empty?
            where("private = false OR user_id = ?", current_user)
        else
            includes(:groups)
            .references(:groups)
            .where("groups.id IN (?) OR private = false OR user_id = ?", ids , current_user)
        end

    }

    scope :order_desc, -> { order(created_at: :desc) }

    scope :search, -> (search_param) {
        joins(:snippet_files)
        .where("lower(snippet_files.filename) LIKE ? OR lower(title) LIKE ?", "%#{search_param.downcase}%", "%#{search_param.downcase}%")
        .distinct
    }

    scope :lang, -> (lang) {
        languages = lang.split(',')
        joins(:snippet_files)
        .where("snippet_files.language IN (?)", languages)
        .distinct
    }

    def groups_valid
        groups.each do |group|
            unless self.user.active_groups.include?(group)
                errors.add :groups, "contain one you do not have permission for"
                return
            end
        end
    end
end
