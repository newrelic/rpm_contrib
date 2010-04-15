# Detect when running under camping and set the framework and dispatcher.

module NewRelic
  # The class defined in the
  # newrelic_rpm[http://newrelic.github.com/rpm] which can be ammended
  # to support new frameworks by defining modules in this namespace.
  class LocalEnvironment
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

