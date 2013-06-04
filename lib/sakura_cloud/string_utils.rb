class String
  def underscorize
    self.split(/(?![a-z])(?=[A-Z])/).map{|s| s.downcase}.join('_')
  end

  def camelize
    self.split('_').map{|s| s.capitalize}.join('')
  end
end
