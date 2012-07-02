module Nibbler; module Views
  class TextField < ViewBase
    view_type UITextField

    def initialize(controller, spec)
      super(controller, spec)

      if spec[:on] && spec[:on][:changed]
        msg = spec[:on][:changed].to_s
        msg += ':' unless msg =~ /.*\:$/      

        NSNotificationCenter.defaultCenter.addObserver(controller, 
          selector: msg.to_sym, 
          name: UITextFieldTextDidChangeNotification, 
          object: view_instance)
      end
    end
  end
end; end