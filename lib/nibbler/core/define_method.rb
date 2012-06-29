module Nibbler
  class IVarMapper
    def initialize(source)
      @source = source
    end

    def [](name)
      @source.instance_variable_get name
    end

    def []=(name, value)
      @source.instance_variable_set name, value
    end
  end
end

class Object
  def singleton_class
    class << self; self end
  end

  # TODO - use inherited and aliasing to allow redefinition of method_missing without breaking
  def method_missing(msg, *args, &block)
    puts "Object#method_missing(#{msg})"    
    proc = self.singleton_class.resolve_dynamic_method(msg) || self.class.resolve_dynamic_method(msg)

    begin
      if !proc.nil?
        args.unshift self     
        res = if block.nil?
          proc.call(*args)
        else
          proc.call(*args, &block)
        end
        return res
      elsif msg != :method_missing! && self.respond_to?(:method_missing!)
        puts "\tdelgating to method_missing!"
        return method_missing!(msg, *args, &block)
      else
          return super(msg, *args, &block)
          # TODO - report RM bug for when block is empty
      end
    rescue NoMethodError => ex
      new_ex = NoMethodError.new("undefined method \`#{msg}' for #{self.inspect}:#{self.class}")
      new_ex.set_backtrace ex.backtrace
      raise new_ex
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

  def _get(name)
    self.instance_variable_get(name)
  end

  def _set(name,value)
    self.instance_variable_set(name, value)
  end

  def _call(msg,*args,&proc)
    self.send(msg, *args, &proc)
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

  def method_added(msg)
    puts "method_added: #{self}##{msg}"
    raise "method_missing is reserved, use method_missing! instead" if msg == :method_missing
  end
end