require 'newrelic_rpm'
module RPMContrib
  VERSION = File.read(File.dirname(__FILE__)+"/../CHANGELOG")[/Version ([\d\.]+)$/, 1]
end
