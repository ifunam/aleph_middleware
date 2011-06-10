require 'yaml'

module Aleph
  module SetupHelpers

    def config
      if File.exist? 'config.yml'
        config = YAML.load_file('config.yml')[ALEPH_ENV]
      end
    end

  end
end
