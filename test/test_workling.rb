require "#{File.dirname(__FILE__)}/helper"
begin
  require 'redis'
  require 'ruby-debug'
rescue LoadError
end

require "#{File.dirname(__FILE__)}/../lib/rpm_contrib/instrumentation/workling"

if defined?(::Workling)


  class WorklingTest < Test::Unit::TestCase

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


    end
  end
end
