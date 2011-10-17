# KyotoTycoon instrumentation

DependencyDetection.defer do
  @name = :kyototycoon

  depends_on do
    defined?(::KyotoTycoon) && !NewRelic::Control.instance['disable_kyototycoon']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing KyotoTycoon instrumentation'
  end

  executes do
    ::KyotoTycoon.class_eval do
      require 'new_relic/agent/method_tracer'
      include NewRelic::Agent::MethodTracer

      [:get, :remove, :set, :add, :replace,
       :append, :cas, :increment, :decrement, :increment_double,
       :set_bulk, :get_bulk, :remove_bulk, :clear, :vacuum,
       :sync, :report, :status, :match_prefix, :match_regex,
       :keys].each do |method|
        add_method_tracer method
      end
    end
  end
end
