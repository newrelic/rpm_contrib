
if defined? ::Resque::Worker

  ::Resque::Worker.class_eval do
    add_method_tracer(:process, 'Resque/Worker/process')
  end

end
