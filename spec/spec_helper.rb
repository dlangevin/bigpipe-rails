ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# get the spec_helper file from our dummy app
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# start the debugger
require "ruby-debug"
Debugger.start

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :mocha
end