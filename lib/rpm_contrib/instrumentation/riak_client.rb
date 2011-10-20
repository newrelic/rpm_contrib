DependencyDetection.defer do
  @name = :riak_client

  depends_on do
    defined?(::Riak) and not NewRelic::Control.instance['disable_riak_client_instrumentation']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Riak client instrumentation'
  end

  executes do
    ::Riak::Client::BeefcakeProtobuffsBackend.class_eval do
      add_method_tracer :fetch_object, 'Database/Riak/fetch_object'
      add_method_tracer :reload_object, 'Database/Riak/reload_object'
      add_method_tracer :store_object, 'Database/Riak/store_object'
      add_method_tracer :delete_object, 'Database/Riak/delete_object'
      add_method_tracer :list_keys, 'Database/Riak/list_keys'
    end
  end
end
