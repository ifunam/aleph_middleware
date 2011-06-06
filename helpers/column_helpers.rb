module Aleph
  module ColumnHelpers

    def blank_spaces_as_suffix(string,length=12)
      if string.size < length
        string << fill_with_blank_spaces(string, length)
      end
      truncate(string,length)
    end

    def fill_with_blank_spaces(string, length)
       ' '  * (length - string.size)
    end

    def truncate(string, length)
      string[0,length]
    end

  end
end
