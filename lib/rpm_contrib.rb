RPM_CONTRIB_LIB = File.dirname(__FILE__)

module RPMContrib
  VERSION = File.read(RPM_CONTRIB_LIB+"/../CHANGELOG")[/Version ([\d\.]+)$/, 1]

  def self.init_sequence
    Proc.new do
      # Tell the agent to load all the files in the
      # rpm_contrib/instrumentation directory.
      NewRelic::Agent.add_instrumentation(RPM_CONTRIB_LIB+"/rpm_contrib/instrumentation/**/*.rb")

      # Load all the Sampler class definitions.  These will register
      # automatically with the agent.
      Dir.glob(RPM_CONTRIB_LIB + "/rpm_contrib/samplers/**/*.rb") { |file| require file }
    end
  end

end

# Perform any framework/dispatcher detection before loading the rpm gem.
raise "The rpm_contrib gem must be loaded before the newrelic_rpm gem." if defined?(::NewRelic)

Dir.glob(RPM_CONTRIB_LIB + "/rpm_contrib/detection/**/*.rb") { |file| require file }

require 'newrelic_rpm'

if defined? Rails
  # Rails 3.x+
  if Rails.respond_to?(:version) && Rails.version =~ /^3/
    module NewRelic
      class Railtie < Rails::Railtie
        initializer("rpm_contrib.start_plugin", &RPMContrib.init_sequence)
      end
    end
  # Rails 2.x
  elsif defined?(Rails) && Rails.respond_to?(:configuration)
    Rails.configuration.after_initialize &RPMContrib.init_sequence
  else
    raise "The rpm_contrib gem supports Rails 2.2+ only."
  end
else
  RPMContrib.init_sequence.call
end