class RemovePendingColumnFromGroupMembers < ActiveRecord::Migration
  def change
      remove_column :group_members, :pending
  end
end
