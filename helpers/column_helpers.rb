module Aleph
  module ColumnHelpers

    def blank_spaces_as_suffix(string,length=12)
      string = string.to_s
      if string.size < length
        string << fill_with_blank_spaces(string, length).to_s
      end
      truncate(string,length)
    end

    def fill_with_blank_spaces(string, length)
      ' '  * (length - string.to_s.size)
    end

    def truncate(string, length)
      string[0,length]
    end

  end
end
