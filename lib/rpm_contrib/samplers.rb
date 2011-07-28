module RpmContrib
  # Samplers are subclasses of NewRelic::Agent::Sampler which periodically collect metric data in a 
  # background thread.  Sampler classes belong in the sampler subdirectory and must be loaded before
  # the agent starts.
  module Samplers
  end
end

pattern = File.expand_path "../samplers/**/*.rb",  __FILE__
Dir.glob pattern do |file|
  begin
    require file.to_s
  rescue Exception => e
    NewRelic::Agent.logger.error "Skipping instrumentation file '#{file}': #{e}"
    NewRelic::Agent.logger.debug e.backtrace.join("\n")
  end
end
