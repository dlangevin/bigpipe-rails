require "bigpipe_rails"
require "rails"

module BigpipeRails
  class Railties < Rails::Engine
    
    engine_name :bigpipe_rails
    
    ApplicationHelper.send(:include, BigpipeRails::Helper)
        
  end
end