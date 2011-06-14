class Address < Sequel::Model(:z304)
  class << self
     include Aleph::ColumnHelpers
     def all_by_key(string)
       key = blank_spaces_as_suffix(string.upcase,12)
       self.where("z304_rec_key = '#{key}01' OR z304_rec_key = '#{key}02'").all
     end
  end

  plugin :validation_helpers
  include Aleph::ColumnHelpers

  attr_accessor :key, :address_type, :fullname, :location, :settlement, :municipality,
                :state, :city, :country, :zipcode, :email, :phone
  set_primary_key :z304_rec_key

  def initialize(*args)
    @address_type = args.first[:address_type] if args.first.is_a? Hash and args.first.has_key? :address_type
    @state = args.first[:state] if args.first.is_a? Hash and args.first.has_key? :state
    @state = args.first[:city] if args.first.is_a? Hash and args.first.has_key? :city
    super *args
  end

  def validate
    validates_presence [:key, :address_type, :fullname, :location, :city, :country, :zipcode, :email]
    validates_unique :z304_rec_key
  end

  def z304_rec_key=(string)
    super [blank_spaces_as_suffix(string.upcase,12), @address_type].compact.join
  end
  alias_method :key, :z304_rec_key
  alias_method :key=, :z304_rec_key=

  def fullname=(string)
    @fullname = blank_spaces_as_suffix(string.to_s.upcase, 50)
  end

  def settlement_and_municipality
    blank_spaces_as_suffix([settlement, municipality].compact.join(', ').upcase, 50)
  end

  def country_state_and_city
    blank_spaces_as_suffix([country, @state, @city].compact.join(', ').upcase, 45)
  end

  def z304_address=(string)
    super [fullname, blank_spaces_as_suffix(string.to_s.upcase, 50), settlement_and_municipality,
           country_state_and_city].join
  end
  alias_method :location, :z304_address
  alias_method :location=, :z304_address=

  def z304_zip=(string)
    super blank_spaces_as_suffix(string, 9)
  end
  alias_method :zipcode, :z304_zip
  alias_method :zipcode=, :z304_zip=

  def z304_address_type=(string)
    super string.to_i.to_s
  end
  alias_method :address_type, :z304_address_type
  alias_method :address_type=, :z304_address_type=

  alias_method :email, :z304_email_address
  alias_method :email=, :z304_email_address=

  alias_method :phone, :z304_telephone
  alias_method :phone=, :z304_telephone=
end
