# Redis instrumentation contributed by Ashley Martens of ngmoco
#
DependencyDetection.defer do
  @name = :redis

  depends_on do
    defined?(::Redis) && !NewRelic::Control.instance['disable_redis']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Redis instrumentation'
  end

  executes do
    ::Redis::Client.class_eval do

      include NewRelic::Agent::MethodTracer

      def self.redis_call_method
        ::Redis::Client.new.respond_to?(:call) ? :call : :raw_call_command
      end


      def raw_call_command_with_newrelic_trace *args
        method_name = args[0].is_a?(Array) ? args[0][0] : args[0]
        metrics = ["Database/Redis/#{method_name}",
                   (NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction? ? 'Database/Redis/allWeb' : 'Database/Redis/allOther')]
        self.class.trace_execution_scoped(metrics) do
          # NewRelic::Control.instance.log.debug("Instrumenting Redis Call[#{method_name}]: #{args[0].inspect}")
          raw_call_command_without_newrelic_trace(*args)
        end
      end

      alias_method :raw_call_command_without_newrelic_trace, redis_call_method
      alias_method redis_call_method, :raw_call_command_with_newrelic_trace

    end
  end
end



