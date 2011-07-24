require File.join("../spec_helper", __FILE__)

describe "BigpipeRails" do
  it "is included in ApplicationHelper" do
    ApplicationHelper.public_instance_methods.should include :bigpipe
  end
  
  describe "GET /test" do
    it "displays bigpipe content as a javascript tag" do
      debugger
      get("/test")
      true
    end
  end
end
