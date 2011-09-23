DependencyDetection.defer do
  @name = :ultrasphinx
    
  depends_on do
    defined?(::Ultrasphinx) and not ::NewRelic::Control.instance['disable_ultrasphinx']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Ultrasphinx instrumentation'
  end
  
  executes do
    class  ::Ultrasphinx::Search
      include NewRelic::Agent::MethodTracer

      add_method_tracer :run
      add_method_tracer :results
    end
  end
end


