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

  attr_accessor :key, :verification_type, :password, :type
  set_primary_key :z308_rec_key

  def validate
    validates_presence [:key, :verification_type, :password, :type]
    validates_unique :z308_rec_key
  end

  def initialize(*args)
    defaults = {:z308_status => 'AC', :z308_encryption => 'N' }
    args.first.merge!(defaults) if args.first.is_a? Hash
    @verification_type = args.first[:verification_type] if args.first.is_a? Hash and args.first.has_key? :verification_type
    super *args
  end

  def z308_rec_key=(string)
     self.z308_id = blank_spaces_as_suffix(string.upcase,12)
     super @verification_type.to_s + blank_spaces_as_suffix(string.upcase,25)
  end
  alias_method :key, :z308_rec_key
  alias_method :key=, :z308_rec_key=

  alias_method  :verification_type, :z308_verification_type
  alias_method  :verification_type=, :z308_verification_type=

  alias_method  :type, :z308_status
  alias_method  :type=, :z308_status=


  def z308_verification=(string)
    super string.strip
  end
  alias_method  :password, :z308_verification
  alias_method  :password=, :z308_verification=
end
