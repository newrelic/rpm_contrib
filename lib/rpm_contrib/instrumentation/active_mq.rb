# == ActiveMQ Instrumentation ==
# Robert R. Meyer
# Blue-Dog-Archolite @ GitHub

module RpmContrib
  module Instrumentation
    module ActiveMessaging
      if defined?(::ActiveMessaging::Processor) and not NewRelic::Control.instance['disable_active_mq'] 
        ::ActiveMessaging::Processor.class_eval do
          class << self
            add_method_tracer :on_message, 'ActiveMessaging/OnMessage'
          end
        end
      end
    end
  end
end
