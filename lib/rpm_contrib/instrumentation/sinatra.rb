DependencyDetection.defer do
  @name = :sinatra_view
  
  depends_on do
    defined?(::Sinatra::Base) and not NewRelic::Control.instance['disable_sinatra_template']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing Sinatra view instrumentation'
  end
  
  executes do
    ::Sinatra::Base.class_eval do
      def render_with_newrelic_trace(*args, &block)
        engine, file = *args
        return render_without_newrelic_trace(*args, &block) if file == "= yield"

        file = "Proc" if file.is_a?(Proc)
        metrics = ["View/#{engine}/#{file}/Rendering"]

        self.class.trace_execution_scoped metrics do
          render_without_newrelic_trace(*args, &block)
        end
      end

      alias render_without_newrelic_trace render
      alias render render_with_newrelic_trace
    end
  end
end
