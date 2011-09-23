# Workling instrumentation contributed by Chad Ingram of Aurora Feint
#
DependencyDetection.defer do
  @name = :workling
  
  depends_on do
    defined?(::Workling) and not ::NewRelic::Control.instance['disable_workling']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Workling instrumentation'
  end

  executes do
    ::Workling::Base.class_eval do
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    end

    ::Workling::Discovery.discovered.each do |clazz|
      (clazz.public_instance_methods - ::Workling::Base.public_instance_methods).each do |method|
        puts "added method tracer Workling/#{clazz.name}/#{method}"
        clazz.send(:add_method_tracer, method, "Workling/#{clazz.name}/#{method}", :category => :task)
      end
    end
  end

end
