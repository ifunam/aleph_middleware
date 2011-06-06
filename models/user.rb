class User
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Dirty

  attr_accessor :key, :fullname, :unit, :academic_responsible, :academic_level,
                :location, :settlement, :municipality, :state, :country, :city,
                :zipcode, :email, :phone, :expiry_date, :new_record

  validates_presence_of :key, :fullname, :unit, :academic_level, :location,
                        :country, :city, :zipcode, :email, :phone, :expiry_date

  def self.first_by_key(key)
    @user = new(:new_record => false, :key => key)
    @user.fill_models
    unless @user.models_empty?
      @user
    else 
      nil
    end
  end

  def initialize(attributes={})
    @models = []
    self.attributes = attributes
    self.new_record = attributes[:new_record] || true
    self
  end

  def valid?
    fill_models if @models.empty?
    if super
      models_valid?
    else
      return false
    end
  end

  def save
    if valid? and new_record?
      save_models
    else
      return false
    end
  end

  def destroy
    unless models_empty?
      @models.each do |record|
        record.destroy
      end
    end
  end

  def models_empty?
    @models.compact.empty?
  end
  #private

  def attributes=(hash)
    sanitize_for_mass_assignment(hash).each do |attribute, value|
      send("#{attribute}=", value)
    end
  end

  def account_attributes
    { :fullname => fullname, :unit => unit, :academic_responsible => academic_responsible,
      :academic_level => academic_level, :key => key
    }
  end

  def new_account
    Account.new account_attributes
  end

  def address_attributes
    { :key => key, :fullname => fullname, :location => location, :settlement => settlement,
      :municipality => municipality, :state => state, :city => city, :country => country,
      :zipcode => zipcode, :email => email, :phone => phone
    }
  end

  def new_address(address_type)
    Address.new address_attributes.merge(:address_type => address_type)
  end

  def keychain_attributes
    { :key => key, :password => key }
  end

  def new_keychain(verification_type)
    KeyChain.new keychain_attributes.merge(:verification_type => verification_type)
  end

  def vigency_attributes
    { :key => key, :expiry_date => expiry_date,
      :unit => unit, :academic_responsible => academic_responsible
    }
  end

  def new_vigency(suffix_key)
    Vigency.new vigency_attributes.merge(:key_suffix => suffix_key)
  end

  def new_record?
    @new_record
  end

  def models_valid?
    @models.each do |model|
      unless model.valid?
        errors.add model.class.name.downcase.to_sym, model.errors.full_messages.join(', ')
      end
    end
    !has_errors?
  end

  def has_errors?
    errors.count > 0
  end

  def save_models
    @models.each do |model|
      record_saved = model.save
      return false unless record_saved
    end
  end

  def fill_models
    @models.clear
    # Check new record bug
    if new_record?
      @models << new_account
      %w(01 02).each do |address_type| @models << new_address(address_type) end
      %w(01 00).each do |verification_type| @models << new_keychain(verification_type) end
      ['ALEPH', LIBRARY_KEY].each do |suffix_key| @models << new_vigency(suffix_key) end
    else
      @models << Account.first_by_key(key)
      Address.all_by_key(key).each do |address| @models << address end
      KeyChain.all_by_key(key).each do |keychain| @models << keychain end
      Vigency.all_by_key(key).each do |vigency| @models << vigency end
    end
  end
end
