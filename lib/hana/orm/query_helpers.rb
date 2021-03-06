module Hana
  module QueryHelpers
    def update_record_placeholders
      columns.map { |property| "#{property}=?" }.join(', ')
    end

    def new_record_placeholders
      (['?'] * properties.size).join(', ')
    end

    def initialize_query_holder
      attr_accessor :id, :created_at
      query_holder = []
      query_holder
    end

    def query_string(constraints)
      query_builder = []
      query_builder << constraints.type
      query_builder << 'primary key autoincrement' if constraints.primary_key
      query_builder << 'not null' unless constraints.nullable || constraints.nullable.nil?
      query_builder.join(' ')
    end

    def table_constraints
      query_holder = initialize_query_holder

      properties.each do |column_name, constraints|
        query_holder << "#{column_name} #{query_string(constraints)}"
      end
      query_holder.join(', ')
    end

    def properties
      @properties[:id] = OpenStruct.new(type: 'integer', primary_key: true)
      @properties[:created_at] = OpenStruct.new(type: 'VARCHAR(10)')
      @properties
    end

    def columns
      properties.keys
    end
  end
end
