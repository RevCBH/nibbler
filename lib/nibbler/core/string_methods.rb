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
end