require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "BigpipeRails" do
  it "is included in ApplicationHelper" do
    ActionView::Base.new.public_methods.should include :bigpipe
  end
end
