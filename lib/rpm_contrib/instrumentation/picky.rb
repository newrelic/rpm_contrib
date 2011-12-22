if defined?(::Picky)

  class Picky::NewRelic
    def self.obfuscate_tokens tokens
      tokens.map { |t|
        o = 'xxx'
        o += '~' if t.similar?
        o += '*' if t.partial?
        o = t.qualifiers.sort.join(',') + ':' + o if t.qualifiers && t.qualifiers.respond_to?(:join)
        o
      }.sort.join(' ')
    end
  end

end

DependencyDetection.defer do
  @name = :picky

  depends_on do
    defined?(::Picky::Search) && !NewRelic::Control.instance['disable_picky']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Picky instrumentation'
  end

  executes do
    ::Picky::Search.class_eval do
      include NewRelic::Agent::MethodTracer

      def execute_with_newrelic_trace *args
        metrics = "Custom/Picky/search: #{Picky::NewRelic.obfuscate_tokens args[0]}"
        self.class.trace_execution_scoped(metrics){ execute_without_newrelic_trace(*args) }
      end

      alias_method :execute_without_newrelic_trace, :execute
      alias_method :execute, :execute_with_newrelic_trace
    end
  end
end
