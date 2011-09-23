DependencyDetection.defer do
  @name = :cassandra
  
  depends_on do
    defined?(::Cassandra) && !NewRelic::Control.instance['disable_cassandra_instrumentation']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Cassandra instrumentation'
  end

  executes do
    ::Cassandra.class_eval do
      add_method_tracer :insert,               'Database/Cassandra/insert'
      add_method_tracer :remove,               'Database/Cassandra/remove'
      add_method_tracer :clear_column_family!, 'Database/Cassandra/clear_column_family!'
      add_method_tracer :clear_keyspace!,      'Database/Cassandra/clear_keyspace!'
      add_method_tracer :count_columns,        'Database/Cassandra/count_columns'
      add_method_tracer :multi_count_columns,  'Database/Cassandra/multi_count_columns'
      add_method_tracer :get_columns,          'Database/Cassandra/get_columns'
      add_method_tracer :multi_get_columns,    'Database/Cassandra/multi_get_columns'
      add_method_tracer :get,                  'Database/Cassandra/get'
      add_method_tracer :multi_get,            'Database/Cassandra/multi_get'
      add_method_tracer :exists?,              'Database/Cassandra/exists?'
      add_method_tracer :get_range,            'Database/Cassandra/get_range'
      add_method_tracer :count_range,          'Database/Cassandra/count_range'
      add_method_tracer :batch,                'Database/Cassandra/batch'
    end
  end
end
