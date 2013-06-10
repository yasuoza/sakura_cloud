class String
  def underscorize
    if self == 'ID'
      self.downcase
    else
      self.split(/(?![a-z])(?=[A-Z])/).map{|s| s.downcase}.join('_') rescue self
    end
  end

  def camelize
    if self == 'id'
      self.uppercase
    else
      self.split('_').map{|s| s.capitalize}.join('')
    end
  end
end

class Symbol
  def underscorenize
    if self == 'ID'
      self.downcase
    else
      self.split(/(?![a-z])(?=[A-Z])/).map{|s| s.downcase}.join('_') rescue self
    end
  end

  def camelize
    if self == 'id'
      self.uppercase
    else
      self.split('_').map{|s| s.capitalize}.join('')
    end
  end
end
