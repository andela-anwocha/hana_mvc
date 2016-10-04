class Hash
  def permit(*args)
    select { |key, _value| args.include?(key) }
  end

  def symbolize_keys
    map { |key, value| [key.to_sym, value] }.to_h
  end
end
