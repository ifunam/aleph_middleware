class Client < Sequel::Model(MIDDLEWARE_DB[:clients])
  plugin :validation_helpers
  def validate
    validate_presence [:ip_address, :emails, :enabled, :name]
    validates_uniqueness :name
  end
  one_to_many :transactions
end
