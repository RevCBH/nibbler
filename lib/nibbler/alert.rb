module Nibbler
  class Alert  
    def show(msg)
      NSLog "Alert: #{msg}"
      # msg = msg.to_s
      # if @alert.nil?
      #   @@alert = UIAlertView.alloc.initWithTitle("Alert", message:msg, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:"OK")
      # end
      # @@alert.setMessage msg
      # @@alert.show
    end
  end
end