class Object
  def singleton_class
    class << self; self end
  end

  # TODO - use inherited and aliasing to allow redefinition of method_missing without breaking
  def method_missing(msg, *args, &block)
    proc = self.singleton_class.resolve_dynamic_method(msg) || self.class.resolve_dynamic_method(msg)
    unless proc.nil?      
      proc.call(args, block) unless block.nil?
      proc.call(args) if block.nil?          
    else
      begin
        super(msg, *args, &block)
      rescue NoMethodError => ex
        new_ex = NoMethodError.new("undefined method \`#{msg}' for #{self.inspect}:#{self.class}")
        new_ex.set_backtrace ex.backtrace
        raise new_ex
      end
    end
  end

  def define_method(msg, &proc)
    singleton_class.define_method(msg, &proc)
  end

  alias_method :respond_to_original?, :respond_to?
  def respond_to?(msg)
    self.respond_to_original?(msg) || 
    !(self.singleton_class.resolve_dynamic_method(msg) || 
      self.class.resolve_dynamic_method(msg)).nil?
  end
end

class Class
  def define_method(msg, &proc)
    (@dynamic_methods ||= {})[msg] = proc
  end

  def implements_dynamic?(msg)
    (@dynamic_methods || {}).has_key?(msg)
  end

  def resolve_dynamic_method(msg)
    if self.implements_dynamic?(msg)
      @dynamic_methods[msg]
    else
      self.superclass.resolve_dynamic_method(msg) if self.superclass
    end
  end
end