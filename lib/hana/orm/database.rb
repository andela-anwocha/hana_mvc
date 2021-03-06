require 'sqlite3'

module Hana
  class Database
    def self.connect
      @db ||= SQLite3::Database.new('app.db')
    end

    def self.execute(*query)
      connect.execute(*query)
    end
  end
end
