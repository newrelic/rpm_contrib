DependencyDetection.defer do
  @name = :mongoid

  depends_on do
    defined?(::Mongoid) and not NewRelic::Control.instance['disable_mongoid']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Mongoid instrumentation'
  end

  executes do
    Mongoid::Collection.class_eval do
      include NewRelic::Agent::MethodTracer

      (Mongoid::Collections::Operations::ALL - [:<<, :[]]).each do |method|
        add_method_tracer method, "ActiveRecord/\#{@klass}/#{method}"
      end
    end
  end
end
