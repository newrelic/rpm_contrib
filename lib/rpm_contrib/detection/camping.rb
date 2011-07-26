module NewRelic #:nodoc:
  # The class defined in the
  # newrelic_rpm[http://newrelic.github.com/rpm] which can be amended
  # to support new frameworks by defining modules in this namespace.
  class LocalEnvironment #:nodoc:
    module Camping
      def discover_framework
        if defined?(::Camping)
          puts "framework is camping"
          @framework = 'camping'
        else
          super
        end
      end
      def discover_dispatcher
        super
        if defined?(::Camping) && @dispatcher.nil?
          @dispatcher = 'camping'
        end
      end
    end
  end
end

