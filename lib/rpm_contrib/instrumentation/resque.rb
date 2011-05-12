
module RPMContrib
  module Instrumentation
    module ResqueInstrumentation
      Resque.before_first_fork do
        NewRelic::Agent.manual_start(:dispatcher => :resque)
      end

      Resque.after_fork do
        NewRelic::Agent.after_fork(:force_reconnect => false)
      end

      Resque.before_child_exit do
        NewRelic::Agent.shutdown
      end
    end
  end
end if defined?(::Resque) and not NewRelic::Control.instance['disable_resque']

module Resque
  module Plugins
    module NewRelicInstrumentation
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation

      def around_perform_with_monitoring(*args)
        perform_action_with_newrelic_trace(:name => 'perform', :class_name => class_name, :category => 'OtherTransaction/ResqueJob') do
          yield(*args)
        end
      end
    end
  end
end
