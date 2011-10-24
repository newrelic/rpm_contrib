DependencyDetection.defer do
  @name = :ripple

  depends_on do
    defined?(::Ripple) and not
      NewRelic::Control.instance['disable_ripple']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Ripple instrumentation'
  end

  executes do
    ::Ripple::Callbacks::InstanceMethods.class_eval do
      add_method_tracer :valid?, 'Database/Riak/Ripple/valid?'
    end

    ::Ripple::Document::Persistence::InstanceMethods.class_eval do
      add_method_tracer :really_save, 'Database/Riak/Ripple/really_save'
      add_method_tracer :reload, 'Database/Riak/Ripple/reload'
      add_method_tracer :delete, 'Database/Riak/Ripple/delete'
    end

    ::Ripple::Document::Finders::ClassMethods.class_eval do
      add_method_tracer :find, 'Database/Riak/Ripple/find'
      add_method_tracer :list, 'Database/Riak/Ripple/list'
    end
  end
end
