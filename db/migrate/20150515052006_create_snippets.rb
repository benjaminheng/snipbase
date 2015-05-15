class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :title
      t.references :user, index: true, foreign_key: true
      t.boolean :private

      t.timestamps null: false
    end
  end
end
