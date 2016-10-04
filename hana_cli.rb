require 'thor'
require_relative 'hana_generator'

module Hana
  VERSION = '0.1.0'.freeze

  class Cli < Thor
    desc 'version', 'Display version'
    map %w(-v --version) => :version

    def version
      say "Hana #{VERSION}"
    end

    desc 'generate', 'generates templates for the project'

    def generate
      generator = Generator.new
      generator.destination_root = File.expand_path('.')
      generator.invoke_all
    end

    desc 'serve', 'serves folder using rack. This needs a config.ru file present to run'

    def serve
      system 'bundle exec rackup'
    end
  end
end
