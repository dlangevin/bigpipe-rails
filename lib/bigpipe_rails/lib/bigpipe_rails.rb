module BigpipeRails
  extend ActiveSupport::Autoload
  autoload :Helper
  
  # root path
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__),".."))
  end
  
  # get the engines file
  require(File.expand_path("engines", File.dirname(__FILE__)))
  
end