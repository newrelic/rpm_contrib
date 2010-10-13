# Workling instrumentation contributed by Chad Ingram of Aurora Feint
#

if defined?(::Workling) and not NewRelic::Control.instance['disable_workling']
  Workling::Discovery.discovered.each do |clazz|
    (clazz.public_instance_methods - Workling::Base.public_instance_methods).each do |method|
      puts "added method tracer Workling/#{klazz.name}/#{method}"
      clazz.send(:add_method_tracer, method, "Workling/#{klazz.name}/#{method}", :category => :task)
    end
  end
end
