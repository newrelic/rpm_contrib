DependencyDetection.defer do
  @name = :riak_client

  depends_on do
    defined?(::Riak) and not NewRelic::Control.instance['disable_riak_client_instrumentation']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Riak client instrumentation'
  end

  executes do
    backend_tracers = proc do
      add_method_tracer :ping, 'Database/Riak/ping'
      add_method_tracer :stats, 'Database/Riak/stats'
      add_method_tracer :server_info, 'Database/Riak/server_info'

      add_method_tracer :get_client_id, 'Database/Riak/get_client_id'
      add_method_tracer :set_client_id, 'Database/Riak/set_client_id'

      add_method_tracer :list_buckets, 'Database/Riak/list_buckets'
      add_method_tracer :get_bucket_props, 'Database/Riak/get_bucket_props'
      add_method_tracer :set_bucket_props, 'Database/Riak/set_bucket_props'

      add_method_tracer :mapred, 'Database/Riak/mapred'
      add_method_tracer :link_walk, 'Database/Riak/link_walk'
      add_method_tracer :get_index, 'Database/Riak/get_index'
      add_method_tracer :search, 'Database/Riak/search'
      add_method_tracer :update_search_index, 'Database/riak/update_search_index'

      add_method_tracer :list_keys, 'Database/Riak/list_keys'
      add_method_tracer :fetch_object, 'Database/Riak/fetch_object'
      add_method_tracer :reload_object, 'Database/Riak/reload_object'
      add_method_tracer :store_object, 'Database/Riak/store_object'
      add_method_tracer :delete_object, 'Database/Riak/delete_object'
    end

    ::Riak::Client::ProtobuffsBackend.class_eval &backend_tracers
    ::Riak::Client::BeefcakeProtobuffsBackend.class_eval &backend_tracers
    ::Riak::Client::HTTPBackend.class_eval &backend_tracers
  end
end
