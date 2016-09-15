require_relative 'query_helpers'
require 'ostruct'
require_relative 'validations'
require_relative 'persistence'
require_relative 'database'
require_relative 'associations'

module Hana
  class BaseModel
    include Hana::Validations
    extend Hana::QueryHelpers
    include Hana::Persistence
    extend Hana::Associations

    Database.connect

    def initialize(attributes = {})
      @errors ||= []
      attributes.each { |column_name, value| send("#{column_name}=", value) }
    end

    def destroy
      Database.execute "DELETE FROM #{table_name} where id=#{id}"
    end

    def self.find(id)
      row = Database.execute("SELECT * FROM #{table_name} WHERE id=#{id}").first
      map_row_to_object(row)
    end

    def self.all
      rows = Database.execute("SELECT * FROM #{table_name}")
      rows.map { |row| map_row_to_object(row) }
    end

    def self.last
      rows = Database.execute <<-SQL
        SELECT * FROM #{table_name} ORDER BY id DESC LIMIT 1
      SQL
      map_row_to_object(rows.first)
    end

    def self.first
      rows = Database.execute <<-SQL
        SELECT * FROM #{table_name} ORDER BY id LIMIT 1
      SQL
      map_row_to_object(rows.first)
    end

    def self.destroy_all
      Database.execute "DELETE FROM #{table_name}"
      Database.execute "DELETE FROM sqlite_sequence where name='#{table_name}'"
    end

    def self.where(attributes = {})
      search_values = attributes.values
      search_place_holders = attributes.keys.map { |key| "#{key}=? " }.join('and ')

      rows = Database.execute <<-SQL, search_values
        SELECT * FROM #{table_name} where #{search_place_holders}
      SQL
      rows.map { |row| map_row_to_object(row) }
    end

    def eql?(model)
      properties.keys.each do |column_name|
        return false unless send(column_name) == model.send(column_name)
      end
      true
    end

    def to_json(args={})
      object = {}
      columns.each{ |column| object[column] = send(column) }
      object.to_json
    end

    private

    def method_missing(method_name, *_args)
      if self.class.methods.include?(method_name)
        return self.class.send(method_name)
      end
    end

  end
end
