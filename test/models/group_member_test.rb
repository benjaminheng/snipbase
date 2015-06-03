require "test_helper"

describe GroupMember do
  let(:group_member) { GroupMember.new }

  it "must be valid" do
    group_member.must_be :valid?
  end
end
