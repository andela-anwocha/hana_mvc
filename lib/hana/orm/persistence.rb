module Hana
  module Persistence
    def self.included(base)
      base.extend ClassMethods
    end

    def new_record
      return false if created_at
      @created_at = Time.now.to_s

      Database.execute <<-SQL, new_record_values
        INSERT INTO #{table_name} (#{columns.join(', ')}) VALUES \
        (#{new_record_placeholders})
      SQL
    end

    def update_record
      Database.execute <<-SQL, new_record_values
        UPDATE #{table_name} SET #{update_record_placeholders}  WHERE \
        id = #{id}
      SQL
    end

    def new_record_values
      values = columns.map { |column| send(column) }
    end

    module ClassMethods
      def map_row_to_object(row)
        return nil unless row
        model = new
        columns.each.with_index(0) do |attribute, index|
          model.send("#{attribute}=", row[index])
        end

        model
      end
    end
  end
end
