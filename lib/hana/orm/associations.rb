module Hana
  module Associations
    def belongs_to(model, options)
      define_method(model) do
        class_name = options[:class_name] || model.capitalize
        model = class_name.constantize
        model.find(send(options[:foreign_key]))
      end
    end

    def has_many(model, options)
      define_method(model) do
        class_name = options[:class_name] || model.capitalize
        model = class_name.constantize
        model.where("#{options[:foreign_key]}": id)
      end
    end
  end
end
