if RUBY_ENGINE != 'opal'
  module Isomorfeus

    # available settings
    class << self
      attr_accessor :activerecord_connection
    end

    # default values
    self.activerecord_connection = {
      adapter: 'sqlite3',
      database: 'development.db'
    }
  end
end