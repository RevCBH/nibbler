module Nibbler
  class Button
    include View

    def initialize(controller, selector)
      @controller = controller
      view_instance = controller.view.select(selector)[0]
      @callbacks = []

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
      NSLog "Handling tap event from button##{sender.tag} with #{@callbacks.count} callbacks"
      @callbacks.each {|msg| @controller.send msg}
    end

    def matches_string?(str)
      @view.titleLabel.text == str
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
end