DependencyDetection.defer do
  depends_on do
    defined?(::Resque)
  end
  executes do
    module Resque::Plugins
      # The plugin definition is a no-op but left in empty for backward compatibility.
      # We were using the plugin to install instrumentation but it required you either 
      # extend Resque::Job or extend this module.  Using the method chaining approach
      # means you don't have to make any modifications to your job classes.
      module NewRelicInstrumentation; end
    end
  end
end

DependencyDetection.defer do
  depends_on do
    defined?(::Resque::Job) and not NewRelic::Control.instance['disable_resque']
  end

  executes do
    # == Resque Instrumentation
    #
    # Installs a hook to ensure the agent starts manually when the worker
    # starts and also adds the tracer to the process method which executes
    # in the forked task.

    # Resque also works in a non forking mode when fork is not supported
    begin
      # IronRuby/JRuby don't support `Kernel.fork` yet
      if Kernel.respond_to?(:fork)
        Kernel.fork{exit!}
      else
        raise NotImplementedError
      end
    rescue NotImplementedError
      $rpm_cant_fork = true
    end

    ::Resque::Job.class_eval do
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation
      old_perform_method = instance_method(:perform)
      define_method(:perform) do
        class_name = (payload_class ||self.class).name
        perform_action_with_newrelic_trace(:name => 'perform', :class_name => class_name,
                                           :category => 'OtherTransaction/ResqueJob') do
          old_perform_method.bind(self).call
        end
        # If we aren't doing true forks, then the shutdown message would end up
        # shutting down the agent in the parent which would cause us to stop sending
        # data.  Data is not sent from the child.
        NewRelic::Agent.shutdown unless $rpm_cant_fork
      end
    end

    ::Resque.before_first_fork do
      NewRelic::Agent.manual_start(:dispatcher => :resque, :sync_startup => true)
    end

    ::Resque.after_fork do
      NewRelic::Agent.after_fork(:force_reconnect => false)
    end
  end
end 
