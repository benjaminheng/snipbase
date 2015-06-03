class AddIdToGroupMembers < ActiveRecord::Migration
  def change
    add_column :group_members, :id, :primary_key
  end
end
