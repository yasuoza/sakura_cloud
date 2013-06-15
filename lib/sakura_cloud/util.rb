class String
  def underscore
    if self == 'ID'
      self.downcase
    else
      self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end

  def camelize
    if self == 'id'
      self.uppercase
    else
      self.split('/').map{|s| s.split('_').map{|t|t.capitalize}.join}.join('::')
    end
  end
end

class Symbol
  def underscore
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
      self.split('/').map{|s| s.split('_').map{|t|t.capitalize}.join}.join('::')
    end
  end
end
