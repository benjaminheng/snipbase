require 'test_helper'

describe User do
    it "can follow and unfollow another user" do
        user1 = create(:user)
        user2 = create(:user, username: "testuser2")

        user1.following?(user2).must_equal false    # user1 not following user2
        user1.follow(user2)
        user1.following?(user2).must_equal true         # user1 following user2
        user2.followed_by?(user1).must_equal true       # user2 followed by user1
        user1.unfollow(user2)
        user1.following?(user2).must_equal false       # user1 not following user2
        user2.followed_by?(user1).must_equal false     # user2 not followed by user1
    end
end
