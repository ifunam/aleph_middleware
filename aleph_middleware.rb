require 'environment'
class AlephMiddleware < Sinatra::Base

  post '/users.xml' do
    authenticate_with_token!
    @user = User.new(params[:user])
    if @user.save
      @user.to_xml
    else
      @user.errors.to_xml
    end
  end

  put '/users/:id.xml' do
    authenticate_with_token!
    @user = User.first_by_key(params[:id])
    @user.update(params[:user])
    unless @user.errors.count > 0
      @user.to_xml
    else
      @user.errors.to_xml
    end
  end

  get '/users/:id.xml' do
    authenticate_with_token!
    @user = User.first_by_key(params[:id])
    unless @user.nil?
      @user.to_xml
    else
      not_found("Cannot find user key")
    end
  end

  delete '/users/:id.xml' do
    authenticate_with_token!
    @user = User.first_by_key(params[:id])
    unless @user.nil?
      @user.destroy
      { :status => :deleted }.to_xml
    else
      not_found("Cannot find user key")
    end
  end

  private
  def authenticate_with_token!
    error 401 if Client.where(:token => env['HTTP_X_ALEPH_TOKEN']).first.nil?
  end
end
