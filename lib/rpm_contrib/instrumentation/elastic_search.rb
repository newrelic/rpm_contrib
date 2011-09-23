# == Elastic Search Instrumentation
#
DependencyDetection.defer do
  @name = :elastic_search
  
  depends_on do
    defined?(::ElasticSearch::Client) && !NewRelic::Control.instance['disable_elastic_search_instrumentation']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Elastic Search instrumentation'
  end
  
  executes do
    ::ElasticSearch::Client.class_eval do
      add_method_tracer :index,  'ActiveRecord/ElasticSearch/index'
      add_method_tracer :get,    'ActiveRecord/ElasticSearch/get'
      add_method_tracer :delete, 'ActiveRecord/ElasticSearch/delete'
      add_method_tracer :search, 'ActiveRecord/ElasticSearch/search'
      add_method_tracer :scroll, 'ActiveRecord/ElasticSearch/scroll'
      add_method_tracer :count,  'ActiveRecord/ElasticSearch/count'
      add_method_tracer :bulk,   'ActiveRecord/ElasticSearch/bulk'
    end
  end
end

