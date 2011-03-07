if defined? Typhoeus
  Typhoeus.class_eval do
    def get_with_newrelic_trace(*args, &block)
      metrics = ["External/#{@address}/Typhoeus/#{args[0].method}","External/#{@address}/all"]
      if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
        metrics << "External/allWeb"
      else
        metrics << "External/allOther"
      end
      self.class.trace_execution_scoped metrics do
        request_without_newrelic_trace(*args, &block)
      end
    end
    alias get_without_newrelic_trace request
    alias get get_with_newrelic_trace
  end
end
