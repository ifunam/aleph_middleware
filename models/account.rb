class Account < Sequel::Model(:z303)
  class << self
    include Aleph::ColumnHelpers

    def first_by_key(key)
      self.where(:z303_rec_key => blank_spaces_as_suffix(key)).first
    end
  end

  plugin :validation_helpers
  include Aleph::ColumnHelpers
  attr_accessor :key, :firstname, :lastname, :unit, :academic_responsible, :library_key, :academic_level
  set_primary_key :z303_rec_key

  def initialize(*args)
    defaults = { :z303_delinq_3=>0, :z303_con_lng=>"SPA", :library_key=> LIBRARY_KEY,
                 :z303_ill_library=> blank_spaces_as_suffix(LIBRARY_KEY, 5),
                 :z303_profile_id => 'ALEPH', :z303_alpha =>"L", :z303_export_consent => "Y",
                 :z303_send_all_letters => "Y"
                }
    args.first.merge!(defaults)
    @firstname = args.first[:firstname]
    @lastname = args.first[:lastname]
    @key = args.first[:key]
    super *args
  end

  def validate
    validates_presence [:key, :firstname, :lastname, :unit, :library_key]
    validates_unique :z303_rec_key
  end

  def z303_rec_key=(string)
    super blank_spaces_as_suffix(string)
  end
  alias_method :key, :z303_rec_key
  alias_method :key=, :z303_rec_key=

  def z303_name=(string)
    super [@lastname, string].join(', ').upcase
  end
  alias_method :fullname, :z303_name
  alias_method :firstname=, :z303_name=

  def z303_name_key=(string)
    length = @key.nil? ? 50 : 38
    super blank_spaces_as_suffix([string, @firstname].join(' ').downcase,length) + @key.to_s
  end
  alias_method :fullname_key, :z303_name_key
  alias_method :lastname=, :z303_name_key=

  def z303_field_2=(string)
    super string.to_s.upcase
  end
  alias_method :unit, :z303_field_2
  alias_method :unit=, :z303_field_2=

  def z303_field_3=(string)
    super string.to_s.upcase
  end
  alias_method :academic_responsible, :z303_field_3
  alias_method :academic_responsible=, :z303_field_3=

  def z303_home_library=(string)
    super blank_spaces_as_suffix(string, 5)
  end
  alias_method :library_key, :z303_home_library
  alias_method :library_key=, :z303_home_library=

  def z303_title=(string)
    super blank_spaces_as_suffix(string.to_s.upcase, 10)
  end
  alias_method :academic_level, :z303_title
  alias_method :academic_level=, :z303_title=
end
