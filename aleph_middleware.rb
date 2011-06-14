require 'environment'
class AlephMiddleware < Sinatra::Base
  before do
    authenticate_with_token!
  end

  post '/users.xml' do
    @user = User.new(params[:user])
    if @user.save
      @user.to_xml
    else
      @user.errors.to_xml
    end
  end

  put '/users/:id.xml' do
    @user = User.first_by_key(params[:id])
    @user.update(params[:user])
    unless @user.errors.count > 0
      @user.to_xml
    else
      @user.errors.to_xml
    end
  end

  get '/users/:id.xml' do
    @user = User.first_by_key(params[:id])
    unless @user.nil?
      @user.to_xml
    else
      not_found("Cannot find user key")
    end
  end

  delete '/users/:id.xml' do
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
    error 401 unless Client.authenticate?(env['HTTP_X_ALEPH_TOKEN'])
  end
end
