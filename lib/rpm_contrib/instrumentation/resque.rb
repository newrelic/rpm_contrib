
module RPMContrib
  SUPPORTS_FORK =
    begin
      # jruby has a Kernel.fork method, but it raises NotImplementedError by default
      if Kernel.respond_to?(:fork)
        Kernel.fork { exit! }
        true
      else
        false
      end
    rescue NotImplementedError
      false
    end

  module Instrumentation
    # == Resque Instrumentation
    #
    # Installs a hook to ensure the agent starts manually when the worker
    # starts and also adds the tracer to the process method which executes
    # in the forked task.
    module Resque
      def self.flush_metric_data
        return if !NewRelic::Agent.agent.started? || NewRelic::Agent.agent.instance_variable_get(:@worker_loop).nil?
        NewRelic::Agent.agent.instance_variable_get(:@worker_loop).run_task
      end

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

          if ::RPMContrib::SUPPORTS_FORK
            NewRelic::Agent.shutdown unless defined?(::Resque.before_child_exit)
          else
            ::RPMContrib::Instrumentation::ResqueInstrumentation.flush_metric_data unless defined?(::Resque.before_child_exit)
          end

        end
      end

      if defined?(::Resque.before_child_exit)
        ::Resque.before_child_exit do |worker|
          if ::RPMContrib::SUPPORTS_FORK
            NewRelic::Agent.shutdown
          else
            ::RPMContrib::Instrumentation::ResqueInstrumentation.flush_metric_data
          end
        end
      end
    end
  end
end if defined?(::Resque::Job) and not NewRelic::Control.instance['disable_resque']
