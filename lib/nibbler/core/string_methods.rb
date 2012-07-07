class String
  def camelize
    self.split('_').map(&:capitalize).join
  end

  def camelize!
    replace self.camelize
  end

  def constantize
    self.split('::').inject(Kernel, :const_get) 
  end

  def blank?
    self.length == 0
  end
end

def NilClass
  def blank?
    true
  end
end