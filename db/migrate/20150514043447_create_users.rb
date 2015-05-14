class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
      t.string :name

      t.timestamps null: false
    end
    add_index :users, :username, :unique => true
  end
end
