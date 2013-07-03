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
    if [/^id$/i, /^cpu$/i, /^cdrom$/i].find{|r| self.match(r) }
      self.upcase
    else
      self.split('/').map{|s| s.split('_').map{|t| t == 'mb' ? t.upcase : t.capitalize}.join}.join('::')
    end
  end
end
