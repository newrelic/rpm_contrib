# == Redis Instrumentation
#

if defined?(::Redis) and not  NewRelic::Control.instance['disable_redis']
  
  ::Redis.class_eval do 
    
    include NewRelic::Agent::MethodTracer
    
    def raw_call_command_with_newrelic_trace *args
      self.class.trace_execution_scoped('Redis') do
        # p "Instrumenting Redis Call!!!!:", args
        raw_call_command_without_newrelic_trace(*args)
      end
    end
    
    alias_method_chain :raw_call_command, :newrelic_trace
    
  end

end
