DependencyDetection.defer do
  @name = :crack_json

  depends_on do
    defined?(::Crack::JSON) && !NewRelic::Control.instance['disable_crack']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Crack::JSON instrumentation'
  end
  
  executes do
    ::Crack::JSON.class_eval do
      class << self
        include NewRelic::Agent::MethodTracer
        add_method_tracer :parse, 'Parser/#{self.name}/parse'
      end
    end
  end
end

DependencyDetection.defer do
  @name = :crack_xml
  
  depends_on do
    defined?(::Crack::XML) && !NewRelic::Control.instance['disable_crack']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Crack::XML instrumentation'
  end
  
  executes do
    ::Crack::XML.class_eval do
      class << self
        include NewRelic::Agent::MethodTracer
        add_method_tracer :parse, 'Parser/#{self.name}/parse'
      end
    end
  end
end
