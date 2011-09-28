require 'rpm_contrib/language_support'

module Resque
  module Plugins
    module NewRelicInstrumentation
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation
      
      def around_perform_with_monitoring(*args)
        begin
          perform_action_with_newrelic_trace(:name => 'perform',
                                             :class_name => self.name,
                                 :category => 'OtherTransaction/ResqueJob') do
            yield(*args)
          end
        ensure
          NewRelic::Agent.shutdown if RPMContrib::LanguageSupport.can_fork?
        end
      end
    end
  end
end

module RPMContrib
  module Instrumentation
    module ResqueInstrumentationInstaller
      def payload_class
        klass = super
        klass.instance_eval do
          extend ::Resque::Plugins::NewRelicInstrumentation
        end
      end
    end
  end
end

DependencyDetection.defer do
  @name = :resque
  
  depends_on do
    defined?(::Resque::Job) and not NewRelic::Control.instance['disable_resque']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Resque instrumentation'
  end
  
  executes do
    # == Resque Instrumentation
    #
    # Installs a hook to ensure the agent starts manually when the worker
    # starts and also adds the tracer to the process method which executes
    # in the forked task.
    ::Resque::Job.class_eval do
      def self.new(*args)
        super(*args).extend RPMContrib::Instrumentation::ResqueInstrumentationInstaller
      end
    end

    ::Resque.before_first_fork do
      NewRelic::Agent.manual_start(:dispatcher => :resque,
                                   :sync_startup => true)
    end

    ::Resque.after_fork do
      NewRelic::Agent.after_fork(:force_reconnect => false)
    end
  end
end 
