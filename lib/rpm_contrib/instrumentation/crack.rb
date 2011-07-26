DependencyDetection.defer do
  depends_on do
    defined?(::Crack::JSON) && !NewRelic::Control.instance['disable_crack']
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
  depends_on do
    defined?(::Crack::XML) && !NewRelic::Control.instance['disable_crack']
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
