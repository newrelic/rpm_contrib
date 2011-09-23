DependencyDetection.defer do
  @name = :paperclip
  
  depends_on do
    defined?(::Paperclip) && !NewRelic::Control.instance['disable_paperclip']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Paperclip instrumentation'
  end
  
  executes do
    ::Paperclip::Attachment.class_eval do
      add_method_tracer :save, 'Paperclip/#{name}/save'
      add_method_tracer :assign, 'Paperclip/#{name}/assign'
      add_method_tracer :post_process, 'Paperclip/#{name}/post_process'
    end

    ::Paperclip::Storage::Filesystem.class_eval do
      add_method_tracer :flush_deletes, 'Paperclip/Storage/flush_deletes'
      add_method_tracer :flush_writes, 'Paperclip/Storage/flush_writes'
    end

    ::Paperclip::Storage::S3.class_eval do
      add_method_tracer :flush_deletes, 'Paperclip/Storage/flush_deletes'
      add_method_tracer :flush_writes, 'Paperclip/Storage/flush_writes'
    end
  end
end
