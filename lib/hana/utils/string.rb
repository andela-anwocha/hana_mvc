class String
  def snakize
    gsub!('::', '/')
    gsub!(/([A-Z][a-z]+[0-9]+)([A-Z][a-z]+)/, '\1_\2')
    gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    gsub!(/([a-z])([A-Z])/, '\1_\2')
    tr!('-', '_')
    downcase!
    self
  end

  def camelize
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map(&:capitalize).join
  end

  def constantize
    Object.const_get(self)
  end
end
