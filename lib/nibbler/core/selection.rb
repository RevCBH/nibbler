module Nibbler
  class Selector    
  end

  class ViewSelector
  end

  class SelectionParser
    def initialze(str)
      parts = str.split('')      
    end

    def parse_part(part)
      if part =~ /([a-zA-Z][a-zA-Z0-9_]*)(\[\])/
      else
        raise "bad selector part '#{part}'"
      end
    end
  end
end