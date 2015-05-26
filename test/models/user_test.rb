require 'test_helper'

describe User do
    it "can add users to group" do
        user1 = users(:user_1)
        user2 = users(:user_2)
        group1 = groups(:group_1)

        user1.groups.must_be_empty
        user1.groups.push(group1)
        user1.groups.must_include(group1)
        group1.users.must_include(user1)
        group1.users.push(user2)
        user2.groups.must_include(group1)
    end
    it "can follow and unfollow another user" do
        user1 = users(:user_1)
        user2 = users(:user_2)

        user1.following?(user2).must_equal false    # user1 not following user2
        user1.follow(user2)
        user1.following?(user2).must_equal true         # user1 following user2
        user2.followed_by?(user1).must_equal true       # user2 followed by user1
        user1.unfollow(user2)
        user1.following?(user2).must_equal false       # user1 not following user2
        user2.followed_by?(user1).must_equal false     # user2 not followed by user1
    end
end
