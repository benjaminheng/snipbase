require 'test_helper'

describe Group do
    before do
        @user1 = create(:user)
        @user2 = create(:user) 
        @group1 = create(:group)
    end
    it "can have users added" do
        @user1.groups.must_be_empty
        @user1.groups.push(@group1)
        @user1.groups.must_include(@group1)
        @group1.users.must_include(@user1)
        @group1.users.push(@user2)
        @user2.groups.must_include(@group1)
    end

    it "can have users invited to it" do
        @group1.owner = @user1
        @user1.invite_to_group(@group1, @user2)
        @group1.pending_users.must_include(@user2)
        @user2.pending_groups.must_include(@group1)
        @user2.active_groups.must_be_empty
        @user2.accept_group_invite(@group1)
        @group1.active_users.must_include(@user2)
        @user2.active_groups.must_include(@group1)
    end

    it "can have many snippets" do
        snippet1 = create(:snippet, user: @user1, title: "testsnippet_1")
        snippet2 = create(:snippet, user: @user1, title: "testsnippet_2", private: true)
        @group1.snippets.size.must_equal 0
        @group1.add_snippet(snippet1);
        @group1.add_snippet(snippet2);
        @group1.snippets.size.must_equal 2
        @group1.remove_snippet(snippet2)
        @group1.snippets.size.must_equal 1
    end
end
