module Nibbler; module Views
  class Button < ViewBase
    view_type UIButton

    def initialize(controller, spec)
      super(controller, spec)
      
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
      view_instance.currentTitle.downcase.include?(str.downcase)
    end

    def text
      view_instance.currentTitle
    end

    def text=(value)
      view_instance.setTitle(value, forState:UIControlStateNormal)
    end
  end
end; end