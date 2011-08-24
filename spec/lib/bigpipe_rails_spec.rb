require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "BigpipeRails" do
  it "is included in ApplicationHelper" do
    ActionView::Base.new.public_methods.should include :bigpipe
    ActionView::Base.new.public_methods.should include :render_bigpipe
  end
  
  it "should move the generated js file into the public directory" do
    # Rails.root is in the dummy app
    Rails.application.config.assets.paths.should include File.join(BigpipeRails.root, "assets")
  end
  
end
