module Aleph
  module ColumnHelpers

    def blank_spaces_as_suffix(string,length=12)
      if string.size < length
        string << fill_with_blank_spaces(string, length)
      end
      string
    end

    def fill_with_blank_spaces(string, length)
       ' '  * (length - string.size)
    end

  end
end
