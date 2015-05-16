require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test "should add users to group" do
        user1 = users(:user_1)
        user2 = users(:user_2)
        group1 = groups(:group_1)

        assert user1.groups.empty?              # groups is empty
        user1.groups.push(group1)
        assert user1.groups.find(group1.id)     # user1 is part of group1
        assert group1.users.find(user1.id)      # group1 contains user1
        group1.users.push(user2)
        assert user2.groups.find(group1.id)     # user2 is part of group1
    end

    test "should follow and unfollow a user" do
        user1 = users(:user_1)
        user2 = users(:user_2)

        assert_not user1.following?(user2)      # user1 not following user2
        user1.follow(user2)
        assert user1.following?(user2)          # user1 following user2
        assert user2.followed_by?(user1)        # user2 followed by user1
        user1.unfollow(user2)
        assert_not user1.following?(user2)      # user1 not following user2
        assert_not user2.followed_by?(user1)    # user2 not followed by user1
    end
end
