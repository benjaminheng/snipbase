class AddAttributesToGroupsUsers < ActiveRecord::Migration
  def change
      add_column :groups_users, :pending, :boolean
      add_column :groups_users, :accepted, :datetime
  end
end
