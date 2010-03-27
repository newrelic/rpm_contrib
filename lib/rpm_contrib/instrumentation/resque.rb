# == Resque Instrumentation
#
# Installs a hook to ensure the agent starts manually when the worker
# starts and also adds the tracer to the process method which executes
# in the forked task.

module RPMContrib
  module Instrumentation
    module ResqueInstrumentation

      ::Resque::Worker.class_eval do
        include NewRelic::Agent::Instrumentation::ControllerInstrumentation
        old_process_method = instance_method(:process)
        define_method(:process) do | *args |
          if args[0]
            class_name = args[0].payload_class.name
          else
            class_name = 'Resque::Job'
          end
          name = 'process'
          perform_action_with_newrelic_trace(:name => name, :class_name => class_name,
                                             :category => 'OtherTransaction/ResqueJob') do
            old_process_method.bind(self).call(*args)
          end
          NewRelic::Agent.shutdown
        end
        
        old_work_method = instance_method(:work)
        
        define_method(:work) do | *args |
          RAILS_DEFAULT_LOGGER.info "Sarting Resque monitoring"
          old_work_method.bind(self).call(*args)
        end
      end
      
    end
  end
end if defined?(::Resque::Worker) and not NewRelic::Control.instance['disable_resque']

