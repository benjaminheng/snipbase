require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test "should add users to group" do
        user1 = users(:user_1)
        user2 = users(:user_2)
        group1 = groups(:group_1)

        assert user1.groups.empty?          # groups is empty
        user1.groups.push(group1)
        assert user1.groups.find(group1.id)    # user1 is part of group1
        assert group1.users.find(user1.id)     # group1 contains user1
        group1.users.push(user2)
        assert user2.groups.find(group1.id)    # user2 is part of group1
    end
end
