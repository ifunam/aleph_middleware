class User
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Dirty

  attr_accessor :key, :fullname, :unit, :academic_responsible, :academic_level,
                :location, :settlement, :municipality, :state, :country, :city,
                :zipcode, :email, :phone, :expiry_date

  validates_presence_of :key, :fullname, :unit, :academic_responsible,
                        :academic_level, :location, :state, :country, :city,
                        :zipcode, :email, :phone, :expiry_date
end
