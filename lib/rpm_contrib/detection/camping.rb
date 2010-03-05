# Detect when running under camping and set the framework and dispatcher.

module NewRelic
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

