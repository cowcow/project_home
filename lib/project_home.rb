
require 'pathname'
require 'yaml'

require_relative "project_home/version"

module ProjectHome
  
  HOME = Pathname($0).dirname.expand_path.ascend.find{ |path| (path+'home.yaml').exist? }.freeze
  
  def home()
    HOME
  end
  
end

p ProjectHome::HOME
