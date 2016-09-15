class Hash
  def permit(*args)
    self.select{ |key, value| args.include?(key) }
  end

  def symbolize_keys
    self.map{ |key, value| [key.to_sym, value] }.to_h
  end
end
