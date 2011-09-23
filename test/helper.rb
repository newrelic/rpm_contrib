require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.expand_path("../../lib/rpm_contrib.rb", __FILE__)

require 'schema.rb'
