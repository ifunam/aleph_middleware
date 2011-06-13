class KeyChain < Sequel::Model(:z308)
  class << self
    include Aleph::ColumnHelpers
    def all_by_key(key)
       key_with_suffix = blank_spaces_as_suffix(key.upcase,25)
       self.where("z308_rec_key = '01#{key_with_suffix}' OR z308_rec_key = '00#{key_with_suffix}'").all
    end
  end

  plugin :validation_helpers
  include Aleph::ColumnHelpers

  attr_accessor :key, :verification_type, :password
  set_primary_key :z308_rec_key

  def validate
    validates_presence [:key, :verification_type, :password]
    validates_unique :z308_rec_key
  end

  def initialize(*args)
    args.first[:z308_encryption] = 'N' if args.first.is_a? Hash
    @verification_type = args.first[:verification_type] if args.first.is_a? Hash and args.first.has_key? :verification_type

    super *args
  end

  def z308_rec_key=(string)
     z308_key_id =  string
     super @verification_type.to_s + blank_spaces_as_suffix(string.upcase,25)
  end
  alias_method :key, :z308_rec_key
  alias_method :key=, :z308_rec_key=

  def z308_key_id=(string)
    super blank_spaces_as_suffix(string.upcase,12)
  end

  alias_method  :verification_type, :z308_verification_type
  alias_method  :verification_type=, :z308_verification_type=

  alias_method  :password, :z308_verification
  alias_method  :password=, :z308_verification=
end
