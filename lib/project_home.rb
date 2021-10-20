# frozen_string_literal: true

require 'pathname'
require 'yaml'

require_relative 'project_home/version'

# ProjectHome
module ProjectHome
  def self.home
    @home ||= begin
      homepath = [Dir.pwd, $PROGRAM_NAME, __FILE__].lazy.map { |file|
        Pathname(file).dirname.expand_path.ascend.find do |path|
          File.exist?(format('%<path>s%<yaml>s', path: path, yaml: 'home.yaml'))
        end.freeze
      }.select { |path| path }.first
      Pathname(homepath)
    end
  end

  def self.const_missing(id)
    if id == :HOME
      const_set(id, ProjectHome.home)
    else
      warn "undefined constant #{id.inspect}"
    end
  end

  def self.require(path)
    Kernel.require (ProjectHome.home + path).to_s
  end

  def self.auto_require
    requires = ProjectHome.config['requires'] || []
    requires.each do |path|
      ProjectHome.require path
    end
  end

  def self.config
    YAML.load_file(format('%<path>s%<yaml>s', path: ProjectHome.home, yaml: 'home.yaml'))
  end
end
