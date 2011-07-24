module BigpipeRails
  extend ActiveSupport::Autoload
  autoload :Helper
  
  # get the engines file
  require(File.expand_path("engines", File.dirname(__FILE__)))
  
end