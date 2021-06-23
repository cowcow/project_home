# frozen_string_literal: true

require 'pathname'
require 'yaml'

require_relative "project_home/version"

module ProjectHome
  def self.home()
    @@home ||= [Dir.pwd, $0, __FILE__].lazy.map{ |file|
      Pathname(file).dirname.expand_path.ascend.find{ |path|
        (path + 'home.yaml').exist?
      }.freeze
    }.select{ |path| path }.first
  end
  def self.const_missing(id)
    if( id == :HOME )
      const_set( id, ProjectHome.home )
    else
      warn "undefined constant #{id.inspect}"
    end
  end

  def self.require( path )
    Kernel::require (ProjectHome.home+path).to_s
  end
  
  def self.auto_require()
    requires = ProjectHome.config['requires'] || []
    requires.each { |path|
      ProjectHome.require path
    }
  end
  
  def self.config()
    YAML.load_file( ProjectHome.home+'home.yaml' )
  end
  
end

