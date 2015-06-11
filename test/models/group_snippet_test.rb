require "test_helper"

describe GroupSnippet do
    before do
        @snippet1 = create(:snippet)
        @snippet2 = create(:snippet)
        @group = create(:group)
    end
    it "should be destroyed when group is destroyed" do
        @group.add_snippet([@snippet1, @snippet2]);
        GroupSnippet.all.size.must_equal 2
        @group.destroy
        GroupSnippet.all.must_be_empty "GroupSnippets not destroyed when group is destroyed"
    end
    it "should be destroyed when snippet is destroyed" do
        @group.add_snippet([@snippet1, @snippet2]);
        GroupSnippet.all.size.must_equal 2
        @snippet1.destroy
        GroupSnippet.all.size.must_equal 1, "GroupSnippet not destroyed when snippet is destroyed"
    end
end
