# == ActiveMQ Instrumentation ==
# Robert R. Meyer
# Blue-Dog-Archolite @ GitHub

DependencyDetection.defer do
  @name = :active_mq
  
  depends_on do
    defined?(::ActiveMessaging::Processor) && !NewRelic::Control.instance['disable_active_mq']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing ActiveMQ instrumentation'
  end

  executes do
    ::ActiveMessaging::Processor.class_eval do
      class << self
        add_method_tracer :on_message, 'ActiveMessaging/OnMessage'
      end
    end
  end
end
