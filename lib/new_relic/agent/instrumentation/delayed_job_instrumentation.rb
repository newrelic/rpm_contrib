module NewRelic::Agent::Instrumentation::DelayedJobInstrumentation
  extend self
  Delayed::Job.class_eval do
    include NewRelic::Agent::Instrumentation::ControllerInstrumentation
    if self.instance_methods.include?('name')
      add_transaction_tracer "invoke_job", :category => :task, :name => '#{self.name}'
    else
      add_transaction_tracer "invoke_job", :category => :task
    end
  end
  
  Delayed::Worker.class_eval do
    def initialize_with_new_relic(*args)
      initialize_without_new_relic(*args)
      NewRelic::.delayed_worker = self          
    end
    
    alias initialize_without_new_relic initialize
    alias initialize initialize_with_new_relic
  end
  
  def delayed_worker=(w)
    @delayed_worker = w
    env = NewRelic::Control.instance.local_env
    env.dispatcher = :delayed_job
    env.dispatcher_instance_id = case
      when @delayed_worker.respond_to?(:name)
        @delayed_worker.name
      when @delayed_worker.class.respond_to?(:default_name)
        @delayed_worker.class.default_name
      else
        "host:#{Socket.gethostname} pid:#{Process.pid}" rescue "pid:#{Process.pid}"
      end
      
      env.append_environment_value 'Dispatcher', @dispatcher.to_s
      env.append_environment_value 'Dispatcher instance id', @dispatcher_instance_id
      
      @delayed_worker
  end
  
  def delayed_worker
    @delayed_worker
  end
  
end if defined?(Delayed::Job)
