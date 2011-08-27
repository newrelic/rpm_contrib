DependencyDetection.defer do
  depends_on do
    defined?(::Yajl::Parser) && !NewRelic::Control.instance['disable_yajl_instrumentation']
  end

  executes do
    ::Yajl::Parser.class_eval do
      class << self
        include ::NewRelic::Agent::MethodTracer
        add_method_tracer :parse, 'Parser/Yajl/parse'
      end
    end
  end
end

DependencyDetection.defer do
  depends_on do
    defined?(::Yajl::Encoder) && !NewRelic::Control.instance['disable_yajl_instrumentation']
  end

  executes do
    ::Yajl::Encoder.class_eval do
      class << self
        include ::NewRelic::Agent::MethodTracer
        add_method_tracer :encode, 'Encoder/Yajl/encode'
      end
    end
  end
end
