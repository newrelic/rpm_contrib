require 'newrelic_rpm'
module RpmContrib
  # Contributed instrumentation files for use with newrelic_rpm gem
  module Instrumentation
  end
end

pattern = File.expand_path "../instrumentation/**/*.rb",  __FILE__
Dir.glob pattern do |file|
  begin
    require file.to_s
  rescue Exception => e
    NewRelic::Agent.logger.error "Skipping instrumentation file '#{file}': #{e}"
    NewRelic::Agent.logger.debug e.backtrace.join("\n")
  end
end
