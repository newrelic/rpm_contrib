require "#{File.dirname(__FILE__)}/helper"
begin
  require 'mongoid'
rescue LoadError
end

require "#{File.dirname(__FILE__)}/../lib/rpm_contrib/instrumentation/mongoid"

if defined?(::Mongoid)
  
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db('animals')
  end

  class Dog
    include Mongoid::Document

    field :name
  end

  class MongoidTest < Test::Unit::TestCase

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
      # Do nothing
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def teardown
      # Do nothing
    end

    # Fake test
    def test_fail
      Dog.create!(:name=>'rover')

    end
  end
end
