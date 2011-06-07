require "rubygems"
require "bundler"
Bundler.setup
Bundler.require(:default)

%w(column_helpers database middleware_migration).each do |name|
  require "helpers/#{name}"
end

%w(account address vigency key_chain
   book_lending book_lending_log user
   client transaction).each do |name|
  require "models/#{name}"
end
