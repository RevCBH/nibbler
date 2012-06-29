module Nibbler; module Views
  class Button
    include View

    def initialize(controller, spec)
      @controller = controller
      selector = spec[:selector]
      self.view_instance = controller.view.select(selector)[0]
      
      @callbacks = []
      self.action = spec[:action]

      view_instance.addTarget(self, action:'handle_tap:', forControlEvents: UIControlEventTouchUpInside)
    end

    def action=(msg)
      if msg.nil? || (!@controller.respond_to?(msg))
        NSLog "Invalid msg: #{msg} for controller of type #{@controller.class}"
      else
        NSLog "Setting handler for tapped event: ##{msg}"
        @callbacks = [msg.to_sym]
      end
    end

    def handle_tap(sender)
      NSLog "Handling tap event from Button##{sender.tag} with #{@callbacks.count} callbacks"
      @callbacks.each {|msg| @controller.send msg}
    end

    def matches_string?(str)
      @view.titleLabel.text == str
    end

    def method_missing!(msg, *args, &block)
      puts "Button#method_missing!(#{msg})"
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

  class Controller < UIViewController
    def self.button(selector={},opts=nil)
      if opts.nil? && selector.kind_of?(Hash)
        opts = selector
        selector = UIButton
      end

      NSLog "Registering button##{selector}"
      opts[:selector] = selector
      opts[:type] = Button
      (@view_specs ||= []) << opts
    end
  end
end; end