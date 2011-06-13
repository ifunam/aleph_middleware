require "rubygems"
require "bundler"
Bundler.setup
Bundler.require(:default)

%w(column_helpers setup_helpers database).each do |name|
  require "helpers/#{name}"
end

%w(initial_schema_20110608121212).each do |migration|
  require "db/migrate/#{migration}"
end

%w(image_uploader).each do |uploader|
  require "uploaders/#{uploader}"
end

%w(account address vigency key_chain
   book_lending book_lending_log user
   client transaction).each do |name|
  require "models/#{name}"
end
