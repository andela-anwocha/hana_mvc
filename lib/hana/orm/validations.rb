module Hana
  module Validations
    attr_accessor :errors

    def self.included(base)
      base.extend ClassMethods
    end

    def validate
      validators = self.class.validators
      return unless validators
      validators.each do |column_name, attributes|
        attributes.each_pair do |key, _value|
          send("validate_#{key}", column_name, attributes)
        end
      end
    end

    def validate_presence(column_name, _attributes)
      if send(column_name).nil? || send(column_name).to_s.empty?
        add_error(column_name, "#{column_name} cannot be empty")
      end
    end

    def validate_length(column_name, attributes)
      attribute_length = send(column_name).length

      if attributes.length[:is] && attribute_length != attributes.length[:is]
        error_message = "#{column_name} must be #{attributes.length[:is]} characters"
        add_error(column_name, error_message)
      else
        validate_min_length(column_name, attributes) if attributes.length[:minimum]
        validate_max_length(column_name, attributes) if attributes.length[:maximum]
      end
    end

    def validate_max_length(column_name, attributes)
      max_length = attributes.length[:maximum].to_i

      if send(column_name).length > max_length
        error_message = "#{column_name} musn't exceed #{max_length} characters"
        add_error(column_name, error_message)
      end
    end

    def validate_min_length(column_name, attributes)
      min_length = attributes.length[:minimum]

      if send(column_name).length < min_length
        error_message = "#{column_name} must be #{min_length} characters atleast"
        add_error(column_name, error_message)
      end
    end

    def validate_numericality(column_name, attributes)
      return unless attributes.numericality
      unless send(column_name).is_a? Numeric
        add_error(column_name, "#{column_name} must be numeric")
      end
    end

    def validate_format(column_name, attributes)
      if send(column_name) !~ attributes.format[:with]
        add_error(column_name, "#{column_name} didn't match pattern")
      end
    end

    def add_error(column_name, error_message)
      error = {}
      error[column_name] = error_message
      errors << error
    end

    module ClassMethods
      def validates(column_name, attributes = {})
        @validators ||= {}
        @validators[column_name] = OpenStruct.new(attributes)
      end

      def validators
        @validators
      end
    end
  end
end
