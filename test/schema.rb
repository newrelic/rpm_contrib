# Use this file to add tables you need to do testing
# These are created in a sqllite memory DB

begin
  require 'sqlite3'
  require 'active_record'
  
  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Schema.define do

    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0
      table.integer  :attempts, :default => 0
      table.text     :handler
      table.string   :last_error
      table.datetime :run_at
      table.datetime :locked_at
      table.string   :locked_by
      table.datetime :failed_at
      table.timestamps
    end

    create_table :stories, :force => true do |table|
      table.string :text
    end
  end
rescue LoadError
  # Skip AR tests
end
