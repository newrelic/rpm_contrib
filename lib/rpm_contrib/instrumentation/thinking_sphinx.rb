DependencyDetection.defer do
  @name = :thinking_sphinx
    
  depends_on do
    defined?(::ThinkingSphinx) and not ::NewRelic::Control.instance['disable_thinking_sphinx']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Thinking Sphinx instrumentation'
  end
  
  executes do
    class ::ThinkingSphinx::Search
      include NewRelic::Agent::MethodTracer

      add_method_tracer :initialize
      add_method_tracer :results
    end
  end
end

