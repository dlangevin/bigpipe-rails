# remove the js file - this is hard-coded becaues it has to happen before the spec helper is loaded
require 'fileutils'
FileUtils.rm_f(File.expand_path(File.dirname(__FILE__) + '/dummy_app/public/javascripts/bigpipe.js'))

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "BigpipeRails" do
  it "is included in ApplicationHelper" do
    ActionView::Base.new.public_methods.should include :bigpipe
    ActionView::Base.new.public_methods.should include :render_bigpipe
  end
  
  it "should move the generated js file into the public directory" do
    # Rails.root is in the dummy app
    File.exists?(File.join(Rails.root,'public','javascripts','bigpipe.js')).should be true
  end
  
end
