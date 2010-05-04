
module RPMContrib
  module Instrumentation
    # == Resque Instrumentation
    #
    # Installs a hook to ensure the agent starts manually when the worker
    # starts and also adds the tracer to the process method which executes
    # in the forked task.
    module ResqueInstrumentation
      ::Resque::Job.class_eval do
        include NewRelic::Agent::Instrumentation::ControllerInstrumentation
        
        old_perform_method = instance_method(:perform)

        define_method(:perform) do
          class_name = (payload_class ||self.class).name
          NewRelic::Agent.reset_stats if NewRelic::Agent.respond_to? :reset_stats
          perform_action_with_newrelic_trace(:name => 'perform', :class_name => class_name,
                                             :category => 'OtherTransaction/ResqueJob') do
            old_perform_method.bind(self).call
          end

          NewRelic::Agent.shutdown unless defined?(::Resque.before_child_exit)
        end
      end

      if defined?(::Resque.before_child_exit)
        ::Resque.before_child_exit do |worker|
          NewRelic::Agent.shutdown
        end
      end
    end
  end
end if defined?(::Resque::Job) and not NewRelic::Control.instance['disable_resque']
