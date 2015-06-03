class AddOwnerColumnToGroup < ActiveRecord::Migration
  def change
      add_reference :groups, :owner, references: :users
  end
end
