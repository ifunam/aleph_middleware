require 'environment'
class AlephMiddleware < Sinatra::Base

  post '/users/' do
    @user = User.new(params[:user])
    if @user.save
      @user.to_xml
    else
      @user.errors.to_xml
    end
  end

  get '/users/:id' do
    @user = User.first_by_key(params[:id])
    unless @user.nil?
      @user.to_xml
    else
      not_found("Cannot find user key")
    end
  end

  delete '/users/:id' do
    @user = User.first_by_key(params[:id])
    unless @user.nil?
      @user.destroy
      { :status => :deleted }.to_xml
    else
      not_found("Cannot find user key")
    end
  end

end
