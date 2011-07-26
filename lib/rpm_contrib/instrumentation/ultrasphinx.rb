DependencyDetection.defer do

  depends_on do
    defined?(::UltraSphinx) and not ::NewRelic::Control.instance['disable_ultrasphinx']
  end

  executes do
    class  ::Ultrasphinx::Search
      include NewRelic::Agent::MethodTracer

      add_method_tracer :run
      add_method_tracer :results
    end
  end
end


