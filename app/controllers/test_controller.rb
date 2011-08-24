class TestController < ApplicationController
  def test
    render(:stream => true)
  end
  def test_with_exception
    render(:stream => true)
  end
end