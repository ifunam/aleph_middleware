require "rubygems"
require "bundler"
Bundler.setup
Bundler.require(:default)

%w(column_helpers database).each do |name|
  require "helpers/#{name}"
end

%w(account address vigency key_chain
   book_lending book_lending_log user).each do |name|
  require "models/#{name}"
end
