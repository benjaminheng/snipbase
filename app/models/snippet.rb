class Snippet < ActiveRecord::Base
    has_many :snippet_files, :dependent => :destroy
    has_many :group_snippets, dependent: :destroy
    has_many :groups, through: :group_snippets, dependent: :destroy

    belongs_to :user
    validates_presence_of :title
    validates :title, length: { maximum: 1024, too_long: "cannot have more than %{count} characters"}
    scope :title, -> (title) { where "title LIKE ?", "%#{title}%" }
    scope :filename, -> (filename) { self.snippet_files.filename(filename) }
    scope :language, -> (language) { self.snippet_files.language(language) }
    scope :priv, -> (priv) { where priv: priv }
    scope :permission, -> (current_user) { where user: current_user }
end
