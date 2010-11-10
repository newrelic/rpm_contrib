if defined?(::Crack) && !NewRelic::Control.instance['disable_crack']
  Crack::JSON.class_eval d
    class << self
      include NewRelic::Agent::MethodTracer
      add_method_tracer :parse, 'Parser/#{self.class.name}/parse'
    end
  end

  Crack::XML.class_eval do
    class << self
      include NewRelic::Agent::MethodTracer
      add_method_tracer :parse, 'Parser/#{self.class.name}/parse'
    end
  end
end