include Aleph::SetupHelpers

ALEPH_ENV = ENV['ALEPH_ENV'] || 'development'
DB = Sequel.connect("oracle://#{config['username']}:#{config['password']}@#{config['host']}:#{config['port']}/#{config['database']}")
LIBRARY_KEY = config['library_key']
MIDDLEWARE_DB = Sequel.connect("sqlite://#{config['middleware_database']}")
