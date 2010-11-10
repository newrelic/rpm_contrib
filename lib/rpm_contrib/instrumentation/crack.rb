if defined?(::Crack) && !NewRelic::Control.instance['disable_crack']
  if defined?(::Crack::JSON)
    ::Crack::JSON.class_eval do
      class << self
        include NewRelic::Agent::MethodTracer
        add_method_tracer :parse, 'Parser/#{self.name}/parse'
      end
    end
  end

  if defined?(::Crack::XML)
    ::Crack::XML.class_eval do
      class << self
        include NewRelic::Agent::MethodTracer
        add_method_tracer :parse, 'Parser/#{self.name}/parse'
      end
    end
  end
end