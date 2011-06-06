class Vigency < Sequel::Model(:z305)
  class << self
    include Aleph::ColumnHelpers

    def all_by_key(key)
     key_with_suffix = blank_spaces_as_suffix(key.upcase,12)
     self.where("z305_rec_key = '#{key_with_suffix}ALEPH' OR z305_rec_key = '#{key_with_suffix}L8D  '").all
    end
  end

  plugin :validation_helpers
  include Aleph::ColumnHelpers

  attr_accessor :key, :key_suffix, :expiry_date, :unit, :academic_responsible
  set_primary_key :z305_rec_key

  def initialize(*args)
    @key_suffix = args.first[:key_suffix]
    super *args
  end

  def validate
    validates_presence [:key, :key_suffix, :expiry_date, :unit]
    validates_unique :z305_rec_key
  end

  def z305_rec_key=(string)
    p @key_suffix
    super [blank_spaces_as_suffix(string.to_s.upcase,12), blank_spaces_as_suffix(@key_suffix.to_s.upcase, 5)].compact.join
  end
  alias_method :key, :z305_rec_key
  alias_method :key=, :z305_rec_key=

  alias_method :expiry_date, :z305_expiry_date
  alias_method :expiry_date=, :z305_expiry_date=

  def z305_field_2=(string)
    super string.upcase
  end
  alias_method :unit, :z305_field_2
  alias_method :unit=, :z305_field_2=

  def z305_field_3=(string)
    super string.to_s.upcase
  end
  alias_method :academic_responsible, :z305_field_3
  alias_method :academic_responsible=, :z305_field_3=

end
