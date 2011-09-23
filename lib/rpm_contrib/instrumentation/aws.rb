# AWS Instrumentation by Brian Doll of New Relic
DependencyDetection.defer do
  @name = :aws
  
  depends_on do
    defined?(::AWS::S3) && !NewRelic::Control.instance['disable_aws-s3']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing AWS instrumentation'
  end

  
  executes do
    # Instrument connections to the AWS-S3 service
    ::AWS::S3::Connection::Management::ClassMethods.module_eval do
      add_method_tracer :establish_connection!, 'AWS-S3/establish_connection!'
    end

    # Instrument methods on Bucket
    ::AWS::S3::Bucket.instance_eval do
      class << self
        add_method_tracer :create,  'AWS-S3/Bucket/create'
        add_method_tracer :find,    'AWS-S3/Bucket/find'
        add_method_tracer :objects, 'AWS-S3/Bucket/objects'
        add_method_tracer :delete,  'AWS-S3/Bucket/delete'
        add_method_tracer :list,    'AWS-S3/Bucket/list'
      end
    end

    # Instrument methods on Bucket instances
    ::AWS::S3::Bucket.class_eval do
      add_method_tracer :[],        'AWS-S3/Bucket/#{self.name}/[]'
      add_method_tracer :new_object,'AWS-S3/Bucket/#{self.name}/new_objects'
      add_method_tracer :objects,   'AWS-S3/Bucket/#{self.name}/objects'
      add_method_tracer :delete,    'AWS-S3/Bucket/#{self.name}/delete'
      add_method_tracer :delete_all,'AWS-S3/Bucket/#{self.name}/delete_all'
      add_method_tracer :update,    'AWS-S3/Bucket/#{self.name}/update'
    end

    # Instrument methods on S3Object
    ::AWS::S3::S3Object.instance_eval do
      class << self
        add_method_tracer :about,   'AWS-S3/S3Object/about'
        add_method_tracer :copy,    'AWS-S3/S3Object/copy'
        add_method_tracer :delete,  'AWS-S3/S3Object/delete'
        add_method_tracer :rename,  'AWS-S3/S3Object/rename'
        add_method_tracer :store,   'AWS-S3/S3Object/store'
      end
    end

    # Instrument methods on S3Object instances
    # Metric names are aggregated across all S3Objects since having a metric for
    # every single S3Object instance and method pair would be fairly useless
    ::AWS::S3::S3Object.class_eval do
      add_method_tracer :value,     'AWS-S3/S3Objects/value'
      add_method_tracer :about,     'AWS-S3/S3Objects/about'
      add_method_tracer :metadata,  'AWS-S3/S3Objects/metadata'
      add_method_tracer :store,     'AWS-S3/S3Objects/store'
      add_method_tracer :delete,    'AWS-S3/S3Objects/delete'
      add_method_tracer :copy,      'AWS-S3/S3Objects/copy'
      add_method_tracer :rename,    'AWS-S3/S3Objects/rename'
      add_method_tracer :etag,      'AWS-S3/S3Objects/etag'
      add_method_tracer :owner,     'AWS-S3/S3Objects/owner'
    end
  end
end

