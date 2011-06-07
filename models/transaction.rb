class Transaction < Sequel::Model(MIDDLEWARE_DB[:transactions])
  plugin :validation_helpers
  def validate
    validates_presence [:content, :status]
  end
  many_to_one :transaction
end
