module Nibbler; module Views
  module View
    def select(selector)
      NSLog "#{view_instance.class}::select(#{selector.class}:#{selector})"
      msg = case selector
      when Class
        :matches_class?
      when Fixnum        
        :matches_fixnum?
      when String        
        :matches_string?
      when Symbol
        :matches_symbol?
      end

      view_instance.subviews.select {|x| x.send msg, selector}
    end

    def view_instance 
      @view
    end

    def view_instance=(v)
      @view = v
    end

    def matches_class?(type)
      view_instance.kind_of? type
    end

    def matches_fixnum?(n)
      view_instance.tag == n
    end

    def matches_string?(str)
      false
    end

    def matches_symbol?(sym)
      matches_string?(sym.to_s)
    end
  end
end; end

class UIView
  include Nibbler::Views::View

  def view_instance
    self
  end
end

class UIButton
  def matches_string?(txt)
    titleLabel.text.downcase[txt]
  end
end