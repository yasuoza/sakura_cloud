require_relative 'string'

class Symbol
  def underscore
    self.to_s.underscore.to_sym
  end

  def camelize
    self.to_s.camelize.to_sym
  end
end
