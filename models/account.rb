class User < Sequel::Model(:z303)
  class << self
    include Aleph::ColumnHelpers

    def first_by_key(key)
      self.where(:z303_rec_key => blank_spaces_as_suffix(key)).first
    end
  end

  plugin :validation_helpers
  include Aleph::ColumnHelpers
  attr_accessor :key, :fullname, :unit, :academic_responsible, :library_key, :academic_level
  set_primary_key :z303_rec_key

  def initialize(*args)
    args.first[:library_key] = LIBRARY_KEY if args.first.is_a? Hash and !args.first.has_key? :library_key
    super *args
  end

  def validate
    validates_presence [:key, :fullname, :unit, :library_key]
    validates_unique :z303_rec_key
  end

  def z303_rec_key=(string)
    super blank_spaces_as_suffix(string)
  end
  alias_method :key, :z303_rec_key
  alias_method :key=, :z303_rec_key=

  def z303_name_key=(string)
    length = key.nil? ? 50 : 38
    super blank_spaces_as_suffix(string.downcase,length) + key
  end
  alias_method :fullname, :z303_name_key
  alias_method :fullname=, :z303_name_key=

  def z303_field_1=(string)
    super string.upcase
  end
  alias_method :unit, :z303_field_1
  alias_method :unit=, :z303_field_1=

  def z303_field_3=(string)
    super string.upcase
  end
  alias_method :academic_responsible, :z303_field_3
  alias_method :academic_responsible=, :z303_field_3=

  def z303_home_library=(string)
    super blank_spaces_as_suffix(string, 5)
  end
  alias_method :library_key, :z303_home_library
  alias_method :library_key=, :z303_home_library=

  def z303_title=(string)
    super blank_spaces_as_suffix(string.upcase, 10)
  end
  alias_method :academic_level, :z303_title
  alias_method :academic_level=, :z303_title=
end
