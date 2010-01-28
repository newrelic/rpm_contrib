# Hook instrumentation and samplers in this gem into the normal RPM
# start up sequence.
require 'newrelic_rpm'
module RPMContrib
  
  lib_root = File.dirname(__FILE__)
  
  # Tell the agent to load all the files in the rpm_contrib/instrumentation directory.
  
  NewRelic::Agent.add_instrumentation(lib_root+"/rpm_contrib/instrumentation/**/*.rb")

  # Load all the Sampler class definitions.  These will register
  # automatically with the agent.
  Dir.glob(lib_root + "/rpm_contrib/samplers/**/*.rb") { |file| require file }
  
  VERSION = File.read(lib_root+"/../CHANGELOG")[/Version ([\d\.]+)$/, 1]
end
