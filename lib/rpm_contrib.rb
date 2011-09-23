RPM_CONTRIB_LIB = File.dirname(__FILE__)

module RPMContrib; end

require 'rpm_contrib/detection'

require 'newrelic_rpm'
require 'rpm_contrib/agent_compatibility'
require 'rpm_contrib/instrumentation'

# Load all the Sampler class definitions.  These will register
# automatically with the agent.
require 'rpm_contrib/samplers'

if defined? Rails
  # Rails 3.x+
  if Rails.respond_to?(:version) && Rails.version =~ /^3/
    module NewRelic
      class Railtie < Rails::Railtie
        initializer("rpm_contrib.start_plugin"){ NewRelic::Control.instance.init_plugin }
      end
    end
  # Rails 2.x
  elsif defined?(Rails) && Rails.respond_to?(:configuration)
    Rails.configuration.after_initialize { NewRelic::Control.instance.init_plugin }
  else
    raise "The rpm_contrib gem supports Rails 2.2+ only."
  end
else
  # If not running Rails, it is important that you load the contrib gem as late 
  # as possible so the agent initializes after everything else.  Either that 
  # or make the following call yourself at the end of your startup sequence
  # (it is idempotent).
  NewRelic::Control.instance.init_plugin 
end

