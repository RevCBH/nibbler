module Nibbler; module Views
  class TextField < ViewBase
    view_type UITextField

    def initialize(controller, spec)
      super(controller, spec)

      if spec[:on] && spec[:on][:changed]
        msg = spec[:on][:changed].to_s
        msg += ':' unless msg =~ /.*\:$/      

        if(controller.respond_to? msg.to_sym)
          NSNotificationCenter.defaultCenter.addObserver(controller, 
            selector: msg.to_sym, 
            name: UITextFieldTextDidEndEditingNotification, #UITextFieldTextDidChangeNotification, 
            object: view_instance)
        else
          puts "WARN: #{controller} does not respond to :#{msg}"
        end
      end

      if spec[:input_accessory_view]
        view_instance.inputAccessoryView = controller.send(spec[:input_accessory_view].to_sym).view_instance
      end
    end
  end
end; end