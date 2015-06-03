class RenameGroupsUsersToGroupMembers < ActiveRecord::Migration
  def change
      rename_table :groups_users, :group_members
  end
end
