require File.join("../spec_helper", __FILE__)

describe "BigpipeRails" do
  describe "GET /test" do
    it "displays bigpipe content as a javascript tag" do
      debugger
      get("/test")
      true
    end
  end
end