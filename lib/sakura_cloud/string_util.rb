class String
  def underscorenize
    if self == 'ID'
      self.downcase
    else
      self.split(/(?![a-z])(?=[A-Z])/).map{|s| s.downcase}.join('_') rescue self
    end
  end
end

