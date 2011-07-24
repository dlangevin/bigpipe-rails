require "bigpipe_rails"
require "rails"

module BigpipeRails
  class Railties < Rails::Engine
    
    engine_name :bigpipe_rails
    # include our helper
    ActionView::Base.send(:include, BigpipeRails::Helper)
    
    # copy over our bigpipe
    FileUtils.mkdir_p(File.join(Rails.root, "public", "javascripts"))
    FileUtils.cp(File.join(BigpipeRails.root, "assets", "bigpipe.js"), File.join(Rails.root, "public", "javascripts"))
    
  end
end