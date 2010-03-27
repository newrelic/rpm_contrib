# Detect when running under camping and set the framework and dispatcher.

module NewRelic
  class LocalEnvironment
    module Resque
      def discover_dispatcher
        super
        if defined?(::Resque::Worker) && @dispatcher.nil?
          @dispatcher = 'resque'
        end
      end
    end
  end
end

