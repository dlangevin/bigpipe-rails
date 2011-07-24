ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# get the spec_helper file from our dummy app
require File.expand_path("../dummy_app/spec/spec_helper.rb",  __FILE__)
# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy_app/db/migrate/", __FILE__)

require 'bigpipe_rails'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

# start the debugger
require "ruby-debug"
Debugger.start

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :mocha
end