require 'test_helper'

describe User do
    before do
        @user1 = create(:user)
        @user2 = create(:user)
    end

    it "can follow and unfollow another user" do
        @user1.following?(@user2).must_equal false    # @user1 not following @user2
        @user1.follow(@user2)
        @user1.following?(@user2).must_equal true         # @user1 following @user2
        @user2.followed_by?(@user1).must_equal true       # @user2 followed by @user1
        @user1.unfollow(@user2)
        @user1.following?(@user2).must_equal false       # @user1 not following @user2
        @user2.followed_by?(@user1).must_equal false     # @user2 not followed by @user1
    end

    it "can accept group invites" do
        group = create(:group, owner: @user1)
        @user1.invite_to_group(group, @user2)
        @user2.accept_group_invite(group)
        @user2.active_groups.must_include group
    end

    it "can decline group invites" do
        group = create(:group, owner: @user1)
        @user1.invite_to_group(group, @user2)
        @user2.pending_groups.count.must_equal 1
        @user2.decline_group_invite(group)
        @user2.pending_groups.must_be_empty
    end
end
