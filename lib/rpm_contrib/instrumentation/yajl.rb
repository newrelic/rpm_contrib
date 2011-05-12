module RpmContrib
  module Instrumentation
    module Yajl
      if defined?(::Yajl::Encoder) and not  ::NewRelic::Control.instance['disable_yajl_instrumentation']
        ::Yajl::Encoder.class_eval do
          class << self
            include ::NewRelic::Agent::MethodTracer
            add_method_tracer :parse, 'Encoder/Yajl/encode'
          end
        end
      end
    end
  end
end

