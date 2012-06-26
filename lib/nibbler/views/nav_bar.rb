module Nibbler
  class NavBar
    include View

    def initialize(controller, selector)
      @controller = controller
      self.view_instance = controller.view.select(selector)[0]
    end

    def button(selector={}, opts=nil)
      if opts.nil? && selector.kind_of?(Hash)
        opts = selector 
        selector = UINavigationBar
      end

      b = select(selector)[0]
      b.target = @controller
      b.action = opts[:action]
    end

    def select(selector)
      case selector
      when :left
        view_instance.items.map(&:leftBarButtonItem)
      else
        super selector
      end      
    end      
  end
end