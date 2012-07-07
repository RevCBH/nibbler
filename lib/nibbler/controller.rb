module Nibbler
  class Controller < UIViewController
    attr_accessor :parent

    def alert(msg)
      Alert.show(msg)
    end

    def self.view_resources(scope=:self)
      @view_resources ||= []
      if scope == :all
        specs = @view_resources.dup
        specs.concat superclass.view_resources(:all) if superclass.respond_to?(:view_resources)
        return specs
      end

      return @view_resources
    end

    def self.resource(type, opts={}, &block)
      opts[:kind] = :resource
      #opts[:source] = source
      unless type.is_a? Class
        type = "Nibbler::Views::#{type.to_s.camelize}".constantize
      end
      opts[:type] = type
      opts[:block] = block if block_given?
      view_resources << opts
    end

    def self.method_missing!(msg, *args, &block)
      begin        
        type = "Nibbler::Views::#{msg.to_s.camelize}".constantize

        if type.kind_of? Class
          singleton_class.define_method(msg) do |x, selector={}, opts, &block|
            puts "#{x.class}##{msg}(#{selector}, #{opts})"
            if opts.nil? && selector.kind_of?(Hash)
              opts = selector
            end

            if selector.kind_of?(Hash) && selector.keys.count == 0              
              puts "Setting selector to #{type.view_type}"
              selector = type.view_type
            end

            # ISSUE - local variable get reused in block due to define_method impl?
            opts = opts.dup

            puts "Registering #{type}##{selector}"
            opts[:selector] = selector
            opts[:kind] = :control
            opts[:type] = type
            opts[:block] = block if block_given?
            specs = x._call(:view_resources) << opts            
          end

          self.send(msg, *args, &block)
        end
      rescue
        raise NameError.new
      end        
    end

    def viewWillAppear(animated)
      super    
      specs = self.class.view_resources(:all).select {|x| x[:kind] == :control}
      resources = self.class.view_resources(:all).select {|x| x[:kind] == :resource}
      puts "#{self.class}#viewWillAppear"
      puts "\t#{resources}"
      puts "\t#{specs}"

      resources.each do |res|
        puts "Loading resource: #{res[:from]}"
        # TODO - support selectors of items inside the nib
        #[[NSBundle mainBundle] loadNibNamed:@"NumpadDismissBar" owner:self options:nil];
        items = NSBundle.mainBundle.loadNibNamed res[:from].to_s.camelize, owner:self, options: nil
        res[:view] = items[0]
        c = res[:type].new(self, res)
        c.instance_variable_set '@controller', self
        res[:block].call(c) if res[:block]
        if res[:as]          
          self.instance_variable_set "@#{res[:as]}", c
          self.define_method(res[:as].to_sym) {|x| x._get("@#{res[:as]}")}          
        end
      end

      specs.each do |spec|
        NSLog "Wiring #{spec[:type]}##{spec[:selector]}"
        c = spec[:type].new(self, spec)
        spec[:block].call(c) if spec[:block]
        if spec[:as]
          self.instance_variable_set "@#{spec[:as]}", c
          self.define_method(spec[:as].to_sym) {|x| x._get("@#{spec[:as]}")}
        end
        (@controls ||= []) << c
      end
    end

    def self.inherited(subclass)      
      super(subclass)

      subclass.define_method(:view_resources) do |x, scope=:self|
        specs = x._get('@view_resources')
        if specs.nil?
          specs._set('@view_resources', [])
          specs = []
        end

        if scope == :all
          specs = specs.dup
          specs.concat x._call(:superclass).view_resources(:all) if x._call(:superclass).respond_to?(:view_resources)          
        end

        return specs
      end

    end

    def transition_to(target, opts={})
      view = target.kind_of?(Class) ? init_view_from_type(target) : target
      view.parent = self
      yield(view) if block_given?
      presentViewController view, animated: (opts[:animated] || false), completion: nil
    end

    def hide_first_responder
      UIApplication.sharedApplication.keyWindow.first_responder.resignFirstResponder
    end
    #alias_method :hideFirstResponder, :hide_first_responder

    private
    def init_view_from_type(type)
      name = type.name
      name["Controller"] = ""
      type.alloc.initWithNibName name, bundle: nil
    end
  end
end