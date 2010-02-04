require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'newrelic_rpm'
require 'rpm_contrib'

class Test::Unit::TestCase
end

require 'schema.rb'
