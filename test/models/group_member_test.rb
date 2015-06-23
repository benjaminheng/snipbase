require "test_helper"

describe GroupMember do
  before do
      @user1 = create(:user)
      @group = create(:group, owner: @user1)
      @user2 = create(:user)
  end

  it "should be destroyed when group is destroyed" do
      @user1.invite_to_group(@group, @user2)
      GroupMember.all.size.must_equal 1
      @group.destroy
      GroupMember.all.must_be_empty
  end
end
