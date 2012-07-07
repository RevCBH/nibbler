module Nibbler; module Views
  class Toolbar < ViewBase
    def button(selector={}, opts=nil)      
      if opts.nil? && selector.kind_of?(Hash)
        opts = selector 
        selector = UIButton
      end

      v = view_instance.select_views(selector)[0].superview
      @controls ||= []
      @controls << Button.new(@controller, view: v, action: opts[:action])
    end
  end
end; end