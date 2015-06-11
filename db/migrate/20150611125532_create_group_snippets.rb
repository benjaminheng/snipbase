class CreateGroupSnippets < ActiveRecord::Migration
  def change
    create_table :group_snippets do |t|
        t.belongs_to :group, index: true
        t.belongs_to :snippet, index: true
      t.timestamps null: false
    end
  end
end
