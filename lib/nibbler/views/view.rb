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
      puts "View#initialize"
      @controller = controller
      selector = spec[:selector]      
      self.view_instance = controller.view.select(selector)[0]
      puts "self.view_instance: #{self.view_instance}"
    end

    def method_missing!(msg, *args, &block)
      puts "ViewBase#method_missing!(#{msg})"
      msg = "set#{$1.capitalize}:".to_sym if msg.to_s =~ /(.*)=/
      puts "\tconverted to: #{msg}"
      puts "\t@view: #{@view}"
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
end

class UIButton
  def matches_string?(txt)
    titleLabel.text.downcase[txt]
  end
end