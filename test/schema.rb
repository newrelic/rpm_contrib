# Use this file to add tables you need to do testing
# These are created in a sqllite memory DB

begin
  require 'sqlite3'
  require 'active_record'

  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Schema.define do

    create_table :stories, :force => true do |table|
      table.string :text
    end
  end
rescue LoadError
  # Skip AR tests
end
