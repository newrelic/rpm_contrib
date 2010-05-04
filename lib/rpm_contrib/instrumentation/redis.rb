# Redis instrumentation contributed by Ashley Martens of ngmoco
#

if defined?(::Redis) and not  NewRelic::Control.instance['disable_redis']
  
  ::Redis.class_eval do 
    
    include NewRelic::Agent::MethodTracer
    
    def raw_call_command_with_newrelic_trace *args
      method_name = args[0].is_a?(Array) ? args[0][0] : args[0]
      metrics = ["Database/Redis/#{method_name}",
                 (NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction? ? 'Database/Redis/allWeb' : 'Database/Redis/allOther')]
      self.class.trace_execution_scoped(metrics) do
        # NewRelic::Control.instance.log.debug("Instrumenting Redis Call[#{method_name}]: #{args[0].inspect}")
        raw_call_command_without_newrelic_trace(*args)
      end
    end
    
    # alias_method_chain :raw_call_command, :newrelic_trace
    alias raw_call_command_without_newrelic_trace raw_call_command
    alias raw_call_command raw_call_command_with_newrelic_trace
    
  end

end
