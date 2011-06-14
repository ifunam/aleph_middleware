require 'digest/sha2'
class Client < Sequel::Model(MIDDLEWARE_DB[:clients])
  plugin :validation_helpers
  one_to_many :transactions

  def self.authenticate?(token)
     !Client.where(:token => token).first.nil?
  end

  def before_create
    self.token ||= create_token
    super
  end

  def validate
    validates_presence [:ip_address, :emails, :enabled, :name]
    validates_unique :name
  end

  private
  def create_token
    Digest::SHA2.hexdigest(Time.now.to_s)
  end
end
