require "test_helper"

describe GroupSnippet do
  let(:group_snippet) { GroupSnippet.new }

  it "must be valid" do
    group_snippet.must_be :valid?
  end
end
