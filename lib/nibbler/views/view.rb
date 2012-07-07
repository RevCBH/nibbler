module Nibbler; module Views
  module View
    def select_views(selector)
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
      
      results = subviews.dup.select {|x| x.send(msg, selector)}      
      results.concat view_instance.subviews.map {|x| x.select_views(selector)}
      results.flatten.compact
    end

    def view_instance 
      @view
    end

    def view_instance=(v)
      @view = v
    end

    def matches_class?(type)
      view_instance.class == type
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

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def view_type(type=nil)
        unless type.nil?                
          @view_type = type
        end

        return @view_type
      end
    end
  end

  class ViewBase
    include View

    def initialize(controller, spec)      
      @controller = controller
      if spec[:view]
        self.view_instance = spec[:view]
      else
        selector = spec[:selector]
        self.view_instance = controller.view.select_views(selector)[0]
      end
    end

    alias_method :select_original, :select_views
    def select_views(selector)
      if selector.nil? || selector.kind_of?(Hash)
        puts "reset selector: #{selector} -> #{self.class.view_type}"
        selector = self.class.view_type        
      end
      select_original(selector)
    end

    def method_missing!(msg, *args, &block)
      puts "ViewBase#method_missing!(#{msg})"
      msg = "set#{$1.capitalize}:".to_sym if msg.to_s =~ /(.*)=/      
      # ISSUE TODO? - if args.last.kind_of?(Hash), search for "#{msg}:#{args.last.keys.join(':')}:"
      if @view.respond_to?(msg)
        NSLog "\tattempting to delegate to view: #{@view}"
        @view.send(msg, *args, &block)
      else
        super(msg,*args,&block)
      end
    end
  end
end; end

class UIView
  include Nibbler::Views::View

  def view_instance
    self
  end

  def first_responder
    return self if self.firstResponder?
    subviews.each {|v| x = v.first_responder; return x if !x.nil?}
    return nil
  end
end

class UIButton
  def matches_string?(txt)
    titleLabel.text.downcase[txt]
  end
end