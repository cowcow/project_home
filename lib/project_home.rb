
require 'pathname'
require 'yaml'

require_relative "project_home/version"

module ProjectHome
  
  HOME = Pathname($0).dirname.expand_path.ascend.find{ |path| (path+'home.yaml').exist? }.freeze
  
  def self.home()
    HOME
  end
  
  def self.require( path )
    Kernel::require HOME+path
  end
  
  def self.config()
    YAML.load_file( HOME+'home.yaml' )
  end
  
end

