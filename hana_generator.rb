require 'thor'
require 'thor/group'

class Generator < Thor::Group
  include Thor::Actions
  desc 'Generate a new filesystem structure'

  def self.source_root
    File.dirname(__FILE__) + '/generator_templates'
  end

  def create_config_file
    puts "Copying Files"
  end

  def create_app_layout
    directory(".")
  end
end
