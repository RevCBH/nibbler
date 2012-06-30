module Nibbler; module Views
  class NavBar
    include View
    view_type UINavigationBar

    def initialize(controller, spec)
      puts "NavBar#initialize(#{controller}, #{spec})"
      @controller = controller
      selector = spec[:selector]

      self.view_instance = controller.view.select(selector)[0]
    end

    def button(selector={}, opts=nil)
      if opts.nil? && selector.kind_of?(Hash)
        opts = selector 
        selector = UINavigationBar
      end

      puts "Creating NavBar button"
      puts "\tselector: #{selector}"
      puts "\topts: #{opts}"

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
end; end