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

    def self.create(attributes = {})
      model = new(attributes)
      model if model.save
    end

    def save
      validate
      if errors.empty?
        new_record || update_record
        reload
      else
        false
      end
    end

    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
      save
    end

    def destroy
      Database.execute "DELETE FROM #{table_name} where id=#{id}"
    end

    def reload
      @id ||= (Database.execute 'SELECT last_insert_rowid()')[0][0]
      columns = Database.execute "SELECT * FROM #{table_name} where id= #{@id}"

      properties.keys.each.with_index(0) do |column, index|
        send("#{column}=", columns[0][index])
      end
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

    def self.create_table
      Database.execute <<-SQL
        CREATE TABLE IF NOT EXISTS #{@table_name} (#{table_constraints})
      SQL
    end

    def self.to_table(table_name)
      @table_name = table_name
    end

    def self.property(column_name, constraints = {})
      @properties ||= {}
      @properties[column_name] = OpenStruct.new(constraints)
      attr_accessor column_name
    end

    class << self
      attr_reader :table_name
    end

    def eql?(model)
      properties.keys.each do |column_name|
        return false unless send(column_name) == model.send(column_name)
      end
      true
    end

    def to_json(_args = {})
      object = {}
      columns.each { |column| object[column] = send(column) }
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
