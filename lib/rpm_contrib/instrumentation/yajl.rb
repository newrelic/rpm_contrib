DependencyDetection.defer do
  @name = :yajl_parser
  
  depends_on do
    defined?(::Yajl::Parser) && !NewRelic::Control.instance['disable_yajl_instrumentation']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Yajl::Parser instrumentation'
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
  @name = :yajl_encoder
  
  depends_on do
    defined?(::Yajl::Encoder) && !NewRelic::Control.instance['disable_yajl_instrumentation']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Yajl::Encoder instrumentation'
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
