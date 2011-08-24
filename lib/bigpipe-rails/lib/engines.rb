require "bigpipe_rails"
require "rails"

module BigpipeRails
  class Railties < Rails::Engine
    
    engine_name :bigpipe_rails
    # include our helper
    ActionView::Base.send(:include, BigpipeRails::Helper)
    # add ourself to the asset pipeline
    Rails.application.config.assets.paths << File.expand_path('../../assets',__FILE__)
  end
end