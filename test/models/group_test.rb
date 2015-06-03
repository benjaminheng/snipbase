require 'test_helper'

describe Group do
    it "can have users added" do
        user1 = create(:user)
        user2 = create(:user, username: "testuser2")
        group1 = create(:group)

        user1.groups.must_be_empty
        user1.groups.push(group1)
        user1.groups.must_include(group1)
        group1.users.must_include(user1)
        group1.users.push(user2)
        user2.groups.must_include(group1)
    end
end
