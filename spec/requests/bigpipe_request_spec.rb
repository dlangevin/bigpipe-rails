require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "BigpipeRails" do
  describe "GET /test" do
    it "displays bigpipe content as a javascript tag" do
      get("/test")
      response.body.should match("Hello!")
      # test to make sure that we aren't re-escaping
      response.body.should_not match("&quot;")
      true
    end
  end
  describe "GET /test_with_exception" do
    it "displays displays bigpipe content even if there is an error later in rendering" do
      get("/test_with_exception")
      response.body.should match("Hello!")
      # should be a 500 page hanging out in there too, that denotes that the output is pushed separately to
      # the browser
      response.body.should match("500.html")
      true
    end
  end
end