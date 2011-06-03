class User
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Dirty

  attr_accessor :key, :fullname, :unit, :academic_responsible, :academic_level,
                :location, :settlement, :municipality, :state, :country, :city,
                :zipcode, :email, :phone, :expiry_date

  validates_presence_of :key, :fullname, :unit, :academic_level, :location,
                        :country, :city, :zipcode, :email, :phone, :expiry_date

  def initialize(*args)
    @models = []
    super *args
  end

  def add_account
    @models << Account.new(:key => key, :fullname => fullname, :unit => unit, 
                           :academic_responsible => academic_responsible,
                            :academic_level => academic_level)
  end

  def add_addresses
    %w(01 02).each do |address_type|
      @models << Addresses.new(:key => key, :address_type => address_type, :fullname => fullname,
                               :location => location, :settlement => settlement,
                               :municipality => municipality, :state => state, 
                               :city => city, :country => country, :zipcode => zipcode,
                               :email => email, :phone => phone)
    end
  end

  def add_keychain
    %w(01 00).each do |verification_type|
        @models << KeyChain.new(:key => key, :verification_type => verfication_type, :password => key)
    end
  end

  def add_vigency
    ['ALEPH', LIBRARY_KEY].each do |suffix|
        @models << Vigency.new(:key => key, :key_suffix => suffix, :expiry_date => expiry_date,
                               :unit => unit, :academic_responsible => academic_responsible)
    end
  end
end
