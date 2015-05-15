class CreateSnippetFiles < ActiveRecord::Migration
  def change
    create_table :snippet_files do |t|
      t.string :filename
      t.string :language
      t.references :snippet, index: true, foreign_key: true
      t.integer :score
      t.string :tags, array: true

      t.timestamps null: false
    end
    add_index :snippet_files, :tags, using: 'gin'
  end
end
