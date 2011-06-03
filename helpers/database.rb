require 'environment'
require 'yaml'

ALEPH_ENV = ENV['ALEPH_ENV'] || 'development'

if File.exist? 'config.yml'
  config = YAML.load_file('config.yml')[ALEPH_ENV]
end

DB = Sequel.connect("oracle://#{config['username']}:#{config['password']}@#{config['host']}:#{config['port']}/#{config['database']}")
LIBRARY_KEY = config['library_key']
