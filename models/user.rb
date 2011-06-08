class User
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Serializers::Xml
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Dirty

  attr_accessor :key, :fullname, :unit, :academic_responsible, :academic_level,
                :location, :settlement, :municipality, :state, :country, :city,
                :zipcode, :email, :phone, :expiry_date, :new_record

  validates_presence_of :key, :fullname, :unit, :academic_level, :location,
                        :country, :city, :zipcode, :email, :phone, :expiry_date

  def self.first_by_key(key)
    @user = new(:new_record => false, :key => key)
    @user.send :fill_models
    unless @user.send :models_empty?
      @user
    else
      nil
    end
  end

  def initialize(attributes={})
    @models = []
    self.attributes = attributes
    self.new_record = (attributes.has_key? :new_record and !attributes[:new_record].nil?) ? attributes[:new_record] : true
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
      @new_record = false
      return true
    else
      return false
    end
  end

  def update(hash={})
    self.attributes = hash
    if valid? and !new_record? and !models_empty?
      update_models
    end
  end

  def destroy
    unless models_empty?
      @models.reverse.each do |record|
        record.destroy
      end
    end
  end

  def attributes
    [:key, :fullname, :unit, :academic_responsible, :academic_level,
     :location, :settlement, :municipality, :state, :country, :city,
     :zipcode, :email, :phone, :expiry_date].inject({}) do |hash, attribute|
      hash[attribute.to_s] = send(attribute.to_s)
      hash
    end
  end

  private

  def attributes=(hash)
    sanitize_for_mass_assignment(hash).each do |attribute, value|
      send("#{attribute}=", value)
    end
  end

  def account_attributes
    { :fullname => fullname, :unit => unit, :academic_responsible => academic_responsible,
      :academic_level => academic_level
    }
  end

  def new_account
    Account.new account_attributes.merge(:key => key)
  end

  def address_attributes
    { :fullname => fullname, :location => location, :settlement => settlement,
      :municipality => municipality, :state => state, :city => city, :country => country,
      :zipcode => zipcode, :email => email, :phone => phone
    }
  end

  def new_address(address_type)
    Address.new address_attributes.merge(:key => key, :address_type => address_type)
  end

  def keychain_attributes
    { :key => key, :password => key }
  end

  def new_keychain(verification_type)
    KeyChain.new keychain_attributes.merge(:verification_type => verification_type)
  end

  def vigency_attributes
    { :key => key, :expiry_date => expiry_date, :unit => unit,
      :academic_responsible => academic_responsible }
  end

  def new_vigency(suffix_key)
    Vigency.new vigency_attributes.merge(:key_suffix => suffix_key)
  end

  def new_record?
    @new_record
  end

  def models_empty?
    @models.compact.empty?
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
      model.save
    end
  end

  def update_models
    # We don't support updates for :key attribute
    @models[0].update(account_attributes)
    @models[1].update(address_attributes)
    @models[2].update(address_attributes)
    @models[3].update(keychain_attributes)
    @models[4].update(keychain_attributes)
    @models[5].update(vigency_attributes)
    @models[6].update(vigency_attributes)
  end

  def fill_models
    @models.clear
    if new_record?
      fill_with_new_records
    else
      fill_with_existent_records
    end
  end

  def fill_with_new_records
    @models << new_account

    %w(01 02).each do |address_type|
      @models << new_address(address_type)
    end

    %w(01 00).each do |verification_type|
      @models << new_keychain(verification_type)
    end

    ['ALEPH', LIBRARY_KEY].each do |suffix_key|
      @models << new_vigency(suffix_key) 
    end
  end

  def fill_with_existent_records
    @models << existent_account

    Address.all_by_key(key).each do |address|
      @models << address
    end
    existent_address

    KeyChain.all_by_key(key).each do |keychain|
      @models << keychain
    end

    Vigency.all_by_key(key).each do |vigency|
      @models << vigency
    end
    existent_vigency
  end

  def existent_account
    @account =  Account.first_by_key(key)
    unless @account.nil?
      self.fullname = @account.fullname
      self.unit = @account.unit
      self.academic_level = @account.academic_level
      self.academic_responsible = @account.academic_responsible
    end
    @account
  end

  def existent_address
    @address =  Address.all_by_key(key).first
    unless @address.nil?
      self.location = @address.location
      self.zipcode = @address.zipcode
      self.email = @address.email
      self.phone = @address.phone
    end
  end

  def existent_vigency
    @vigency = Vigency.all_by_key(key).first
    self.expiry_date = @vigency.expiry_date unless @vigency.nil?
  end
end
