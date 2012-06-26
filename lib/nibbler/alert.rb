module Nibbler
  class Alert  
    def self.show(msg)
      msg = msg.to_s
      unless @alert
        @alert = UIAlertView.alloc.initWithTitle("Alert", message:msg, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:"OK")
      end
      @alert.setMessage msg
      @alert.show
    end
  end
end