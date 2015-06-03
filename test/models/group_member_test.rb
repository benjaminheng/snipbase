require "test_helper"

describe GroupMember do
  before do
      @group = create(:group)
      @user1 = create(:user)
      @group.owner = @user1
      @user2 = create(:user, username: 'testuser2')
  end

  it "should be destroyed when group is destroyed" do
      @user1.invite_to_group(@group, @user2)
      GroupMember.all.size.must_equal 1
      @group.destroy
      GroupMember.all.must_be_empty
  end
end
