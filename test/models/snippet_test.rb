require 'test_helper'

describe Snippet do
    before do
        @snippet = create(:snippet)
    end

    it "can have many groups" do
        group1 = create(:group)
        group2 = create(:group)
        @snippet.groups.size.must_equal 0
        group1.add_snippet(@snippet)
        group2.add_snippet(@snippet)
        @snippet.reload
        @snippet.groups.size.must_equal 2
        group1.remove_snippet(@snippet)
        @snippet.reload
        @snippet.groups.size.must_equal 1
    end
end
