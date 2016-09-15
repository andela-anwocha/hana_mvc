module Hana
  module StaticValidations
    def validates(column_name, attributes = {})
      @validators ||= {}
      @validators[column_name] = OpenStruct.new(attributes)
    end

    def validators
      @validators
    end
  end
end
